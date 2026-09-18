# Solution — 07

Only if dire.

---

```bsv
   Reg #(Bit #(8)) u <- mkReg (0);
   Reg #(Bit #(8)) d <- mkReg (100);
   Reg #(Bit #(8)) s <- mkReg (0);

   rule count_up (u < 200);
      u <= u + 1;
   endrule

   rule count_down (d > 0);
      d <= d - 1;
   endrule

   rule count_slow (u < 50);
      s <= s + 1;
   endrule

   method Bit #(8) up   = u;
   method Bit #(8) down = d;
   method Bit #(8) slow = s;
```

## Why it is written this way

**`d > 0`, not `d >= 0`.** `d` is a `Bit#(8)` — unsigned — so `d >= 0` is true for
every possible value, the rule fires forever, and `d` wraps 0 → 255. This is the
one genuine trap in the problem, and it is the same trap as in Verilog: an unsigned
value is never negative, so a `>= 0` guard is always true. BSV does not save you
here; only the types do, and only if you reach for `Int#(8)`.

**Three separate rules, not one.** They write three different registers, so `bsc`
proves they never conflict and fires all three in the same cycle whenever their
conditions hold. Splitting logic into small guarded rules is the normal BSV style —
there is no cost, and each rule states one fact about the design.

**Compare with `.check/Ref.bsv`**, which does the same thing as a single
unconditional rule with three `if`s. Identical hardware, identical waveform. So why
prefer the guarded form?

Because the guard is *visible to the compiler* and the `if` is not.

- `bsc` knows `count_up` cannot fire when `u == 200`. It can use that to prove
  non-interference with other rules, and it will warn you if a guard makes a rule
  dead entirely.
- Guards propagate. A rule that calls a not-ready method becomes not-ready itself.
  That is the mechanism behind every FIFO, every handshake, and all of the
  backpressure you will write from problem 13 onward — and it only works through
  guards, never through `if`.
- An `if` inside a rule is opaque: the rule still fires, still counts as having
  "executed", and still conflicts with anything else writing those registers.

The rule of thumb: **an `if` chooses between actions; a guard decides whether the
action happens at all.** When the honest statement is "this should not happen yet",
that is a guard.

## What to take forward

You now have the two halves of BSV's execution model:

- **a rule is atomic** — all of it, or none of it (problem 06)
- **a rule is guarded** — it fires only when its condition holds (problem 07)

Problem 08 puts them together and asks what happens when two guarded atomic rules
want the same register in the same cycle. That is where `bsc` starts making
decisions on your behalf, and where you learn to take them back.
