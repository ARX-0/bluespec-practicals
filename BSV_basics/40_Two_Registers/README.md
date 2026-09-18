# 40 — Two Registers, One Rule

**Concept** everything a rule reads is this cycle's value; everything it writes
lands next cycle.

## The rule

A rule can write several registers, and they all update together:

```bsv
rule swap;
   ra <= rb;
   rb <= ra;
endrule
```

This really does exchange them. `rb` on the right is `rb`'s **current** value, and
`ra` on the right is `ra`'s current value — both reads happen before either write
takes effect. No temporary is needed, and adding one would be wrong for the same
reason it is wrong in Verilog's `<=`.

Say it once and keep it: **within a rule, reads see the old state and writes
create the new state.** The rule is a single instant. This is why a rule is
described as *atomic*, and why the guard in problem 37 either lets all of it
happen or none of it.

## Example

```bsv
rule shift;
   s0 <= inBit;
   s1 <= s0;      // s1 gets the OLD s0 -- a shift register, not a broadcast
   s2 <= s1;
endrule
```

## Your job

| method | must return |
|---|---|
| `getA()` | `0x11`, `0x22`, `0x11`, `0x22`, … alternating each cycle |
| `getB()` | the other one — always the opposite of `getA()` |

Write one rule with two assignments. Do not add a third register.

## vs Verilog

The same rule holds for `<=` in an `always` block, so `a <= b; b <= a;` swaps
there too. The difference is that Verilog also offers `=`, which does not, and
mixing the two in one block is the classic source of a design that simulates one
way and synthesises another. BSV has only `<=`.

## Run it

```
Basics
```
