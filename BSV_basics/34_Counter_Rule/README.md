# 34 — A Rule

**Concept** `rule` — the only thing in BSV that can change state.

## The rule

```bsv
rule increment;
   r <= r + 1;
endrule
```

A rule is a block of actions that happen **together, in one cycle, or not at
all**. This one has no condition, so it fires on every cycle, forever.

Two things to hold on to:

- **`<=` is the only way to write a register**, and it takes effect *next* cycle.
  Inside the rule, `r` still reads the old value — so `r <= r + 1` is a counter,
  not a fixed point.
- **A rule is not a process.** It does not run "at" a time or wait for anything.
  Every cycle, `bsc`'s scheduler asks which rules can fire and fires them.

Methods, by contrast, do not act on their own. `count()` here just exposes `r`.

## Your job

Add a rule that increments `r` by one every cycle. The register and the method
are already written.

| method | must return |
|---|---|
| `count()` | a value one larger on each successive cycle |

The counter is 8 bits, so it wraps from 255 to 0. That is correct, not a bug.

## vs Verilog

```verilog
always @(posedge clk)
   r <= r + 1;
```

Nearly identical — and that similarity is a trap. A Verilog `always` block runs
whenever its clock ticks, full stop. A BSV rule runs when the **scheduler** lets
it, and from problem 36 onward it will sometimes be told not to. That difference
is the whole of chapter G.

## Run it

```
Basics
```
