# 07 — Rule Guards

**Difficulty** ▮▮▮▯▯ · **Concepts** rule conditions, guards vs `if`, "cannot fire" vs "fires and does nothing" · **Prereq** 06

---

## The Verilog you'd write

```verilog
always @(posedge clk)
   if (!rst) begin
      if (up   < 200) up   <= up + 1;      // saturate
      if (down > 0)   down <= down - 1;
      if (up   < 50)  slow <= slow + 1;
   end
```

Three saturating counters, three `if`s. In Verilog an `if` is the *only* tool: the
block runs every cycle and the `if` decides whether anything changes.

## The problem

| method | behaviour |
|---|---|
| `up` | counts 0,1,2,… and **stops at 200**. Never wraps. |
| `down` | counts 100,99,… and **stops at 0**. Never wraps. |
| `slow` | counts up by 1 each cycle **while `up` < 50**, then stops |

Write each as a **rule with a condition**, not as an `if` inside an unconditional
rule. Both give the right answer here — the README explains why you should learn
the guarded form anyway.

## Tutorial: the BSV you need

A rule may carry a condition in parentheses:

```bsv
rule count_up (u < 200);
   u <= u + 1;
endrule
```

Read that as: **"this rule is only *allowed to fire* when `u < 200`."** When the
condition is false the rule does not fire at all. Not "fires and skips the body" —
does not fire.

The distinction against the `if` form:

```bsv
rule count_up;                 // fires EVERY cycle
   if (u < 200) u <= u + 1;    // and sometimes does nothing
endrule
```

Same waveform. Different meaning to the compiler.

**Why the difference matters.** A rule's condition is part of its *schedule*.
`bsc` knows when the rule can fire, and uses that:

- to prove two rules never fire together, so they do not conflict;
- to propagate readiness outward — a method calling a not-ready thing becomes
  not-ready itself, and that is how backpressure works in BSV (problem 13, 17);
- to warn you when a rule can *never* fire, which is a real bug it can catch at
  compile time.

None of that is available for a condition hidden inside an `if`. To `bsc`, the
`if` form is a rule that always fires and whose body happens to be conditional —
opaque.

**Conditions are `Bool`.** `u < 200` is a `Bool`. `u[0]` is a `Bit#(1)` and will
not do; write `u[0] == 0`.

**Several rules can share state.** All three of these read or write different
registers here, so they never conflict and all three fire in the same cycle
whenever their conditions hold.

## What changed from Verilog

- **"Cannot fire" is a first-class idea.** Verilog has no equivalent. An `always`
  block always runs. A BSV rule is a *guarded atomic action*, and the guard is
  visible to the compiler.
- **Guards compose upward.** This is the part with no Verilog analogue at all. If
  a rule calls a method that is not ready, the rule cannot fire — automatically,
  with no wiring. Chain that through a design and you get flow control for free.
  You will see it properly in problems 13 and 17; this problem is where the
  mechanism is introduced.
- **The compiler can tell you a rule is dead.** `bsc` warns "rule X can never
  fire". You are about to meet that warning for real in problem 08.
- **Saturation needs no special care.** `rule (u < 200)` cannot overflow because it
  cannot fire at 200. In Verilog you write the same guard as an `if` and hope
  nobody later adds a second writer.

## How you're checked

300 cycles — long enough for all three counters to reach their limits and sit
there. The reference deliberately uses the **unguarded `if` form**, so it produces
identical behaviour and tells you nothing about the guarded style. Compare the two
files afterwards.

## Run it

```
Run
```
