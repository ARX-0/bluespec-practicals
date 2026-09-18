# 08 — Rule Conflicts and Scheduling

**Difficulty** ▮▮▮▮▯ · **Concepts** conflicts, urgency, `descending_urgency`, reading `bsc`'s schedule warnings · **Prereq** 07

---

> **Run the checker before you edit anything.** The rules are already written and
> already correct in isolation. The bug is in the *schedule*, and `bsc` will tell
> you about it in so many words. Learning to read that message is the problem.

## The Verilog you'd write

```verilog
always @(posedge clk)
   if (count == 9) begin count <= 0; resets <= resets + 1; end
   else count <= count + 1;
```

One `always` block, one priority chain, no ambiguity — because you serialised it
yourself, by hand, in the order you typed the `if`/`else`.

## The problem

`Top.bsv` already contains this:

```bsv
rule do_incr;
   count_r <= count_r + 1;
endrule

rule do_reset (count_r == 9);
   count_r  <= 0;
   resets_r <= resets_r + 1;
endrule
```

`count` must go 0,1,…,9,0,1,… and `resets` must count the wraps.

Both rules write `count_r`. They cannot both fire in the same cycle. **Add one
attribute** so `bsc` resolves the conflict the way you intend. Do not rewrite the
logic.

## Tutorial: the BSV you need

**Two rules conflict when they cannot both fire in the same cycle.** Here both
write `count_r`, and a register has one write port, so at most one may fire.

**`bsc` will not refuse to compile.** It picks an order, tells you which one it
picked, and moves on:

```
Warning: (G0010)
  Rule "do_incr" was treated as more urgent than "do_reset".
Warning: (G0021)
  According to the generated schedule, rule `do_reset' can never fire.
```

That second warning is the bug, stated exactly. `do_incr` has no condition, so it
is *always* ready; if it always wins, `do_reset` never gets a turn, `count_r` sails
past 9 and wraps at 255.

Left to itself, `bsc` breaks ties by **source order** — earlier rule, higher
urgency. Never rely on that. State the intent:

```bsv
(* descending_urgency = "do_reset, do_incr" *)
```

Placed immediately above the rules, it means: when both are ready, `do_reset` wins
and `do_incr` does not fire this cycle. Most urgent first, comma-separated.

**Urgency and conflict are two different questions**, and it is worth keeping them
apart from the start:

| question | what it decides |
|---|---|
| **conflict** | *can* these two rules fire in the same cycle? (determined by what they touch) |
| **urgency** | if they conflict and both are ready, *which one wins*? (you decide) |

`descending_urgency` answers only the second. It never makes conflicting rules fire
together — nothing can.

## What changed from Verilog

- **You did not write a priority encoder; you declared a priority.** In Verilog,
  order-of-evaluation *is* the priority, welded into the `if`/`else` chain. In BSV
  the two rules stay independent and the priority is one line you can change,
  review, or find later.
- **The compiler finds the conflict for you.** It is not possible to *accidentally*
  have two writers to a register in BSV. In Verilog two `always` blocks driving one
  `reg` is a multiple-driver error at best and a race at worst; here it is a
  scheduling question the compiler raises and you answer.
- **"Can never fire" is a compile-time diagnostic.** This class of bug — logic that
  is present, correct, and unreachable — is normally found by staring at waveforms.
  `bsc` states it in one line.
- **Warnings, not errors.** `bsc` compiled this happily. Get in the habit of reading
  its schedule warnings; `Run` prints them for you when a check fails.

## How you're checked

120 cycles, 12 full wrap-arounds, comparing `count` and `resets` every cycle. The
reference does the whole thing in one rule with an `if`/`else`, so no conflict can
arise there and it says nothing about how to resolve one.

Your first run will fail at cycle 8 with `count exp 0 got 10`, and `Run` will print
`bsc`'s scheduling warnings underneath. That is the intended experience.

## Run it

```
Run
```
