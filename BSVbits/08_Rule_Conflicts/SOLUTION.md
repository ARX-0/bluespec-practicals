# Solution — 08

Only if dire.

---

One line, immediately above `rule do_incr`:

```bsv
   (* descending_urgency = "do_reset, do_incr" *)
   rule do_incr;
      count_r <= count_r + 1;
   endrule

   rule do_reset (count_r == 9);
      count_r  <= 0;
      resets_r <= resets_r + 1;
   endrule
```

Nothing else changes.

## Why it is written this way

**The logic was never wrong.** Both rules say something true: "normally count up",
and "at 9, wrap and tally". The defect was that `bsc` had no way to know which
should win when both were ready, so it fell back on source order — and source order
happened to starve the rule that mattered. The fix states the priority instead of
inheriting it by accident.

**Why the unconditional rule starves the guarded one.** `do_incr` has no condition,
so it is ready every cycle. Whichever rule is more urgent takes the register every
cycle it is ready. If that is `do_incr`, `do_reset` never gets a turn — hence
`G0021: rule do_reset can never fire`. Making `do_reset` more urgent inverts this:
it is ready only on the cycles where `count_r == 9`, so it takes the register on
exactly those cycles and `do_incr` runs on all the others.

**The attribute's placement is not obvious.** It attaches to the *group of rules*
that follows, so it goes above the first one, and the names in the string may be
listed in any order relative to where the rules appear in the file. Most urgent
first.

**Why not just reorder the rules in the file?** Writing `do_reset` above `do_incr`
does fix this program, because source order is the tiebreak. Do not do it. It makes
correctness depend on the order of two textual blocks, with nothing saying so —
the next person to tidy the file breaks the design silently. The attribute is the
same decision written down where it can be seen.

**Why not merge them into one rule with an `if`/`else`?** That also works, and it is
what `.check/Ref.bsv` does. It is the right answer when two behaviours really are one
decision. It is the wrong answer when they are independent behaviours that happen to
share a resource — and it does not scale: three or four writers become an
if/else chain you must maintain by hand, which is precisely the Verilog situation
BSV is replacing.

## What to take forward

**Conflict and urgency are separate questions.**

- *Conflict* is determined by what the rules touch. You do not choose it; you can
  only change it by changing what the rules do (or by using a `CReg` — problem 10,
  which lets two rules share a register in one cycle *in a defined order*).
- *Urgency* is a tiebreak between conflicting, simultaneously-ready rules. You
  choose it, with `descending_urgency`.

**Read `bsc`'s schedule warnings.** They are not noise. `G0010` (urgency was chosen
for you), `G0021` (rule can never fire) and `G0036` (rules are mutually exclusive)
describe the actual behaviour of your hardware, and they are the closest thing in
any HDL to being told your bug in English. `Run` surfaces them whenever a check
fails.

The habit to build: when a BSV design misbehaves, look at the schedule before you
look at the logic.
