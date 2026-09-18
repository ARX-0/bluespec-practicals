# 22 — The same machine, by hand

**Difficulty** ▮▮▮▮▯ · **Concepts** explicit state registers, idle markers, restoring division · **Prereq** 21

---

## The Verilog you'd write

The classic divider: a `state` register, a step counter, and a shift-subtract loop in
an `always` block. You have written this one.

## The problem

**Restoring division**, 16 iterations, one per cycle:

| method | behaviour |
|---|---|
| `start(num, den)` | begin `num / den`. Guarded: only when idle. `den` is never 0 |
| `result()` | quotient and remainder, as a `DivResult` struct. Guarded |

The algorithm:

```
rem = 0;  quo = num;
repeat 16 times:
   shift the top bit of quo into the bottom of rem
   shift quo left by 1
   if (rem >= den) { rem -= den;  set quo's bottom bit }
```

After 16 iterations `quo` holds the quotient and `rem` the remainder.

Write it with **an explicit state register and guarded rules** — not `StmtFSM`. The
point is to see what problem 21 was doing for you, and when you would want it back.

## Tutorial: the BSV you need

Nothing new — this is problem 20's structure with different arithmetic. The pieces:

**An idle marker one past the end of the counter's range:**

```bsv
Reg #(Bit #(5)) step <- mkReg (16);      // 16 == idle, 0..15 == working
```

`step` needs 5 bits to hold 16. Now `start`'s guard (`step == 16`) and the iteration
rule's guard (`step < 16`) are **provably mutually exclusive**, so `bsc` knows the two
never fire together even though both write `step`. No `descending_urgency` needed
(problem 08) — the guards did it.

**Compute into locals, then decide where they go:**

```bsv
rule iterate (step < 16);
   Bit #(16) r2 = (rem << 1) | zeroExtend (quo[15]);
   Bit #(16) q2 = quo << 1;

   Bit #(16) d = zeroExtend (den_r);
   if (r2 >= d) begin
      r2 = r2 - d;
      q2 = q2 | 1;
   end

   if (step == 15) begin
      outQ.enq (DivResult { quo: q2, rem: r2 });   // last step: publish
      step <= 16;                                  // and go idle
   end
   else begin
      quo  <= q2;
      rem  <= r2;
      step <= step + 1;
   end
endrule
```

`r2` and `q2` are plain values bound with `=`, so they update within the cycle as the
`if` refines them. Only the final `<=` writes are registers. Mixing the two levels
deliberately — combinational locals, then one register write — is the normal shape of
a BSV datapath rule.

**Why the remainder fits in 16 bits.** `den` is 8 bits, so the remainder is always
below 256; after a left shift it is below 512. Plenty of room. Had `den` been 16 bits
you would need 17 for the shifted remainder — a real and easily-missed overflow.

## What changed from Verilog

- **"Idle" is a guard, not a state you must remember to leave.** `start` is simply not
  ready while `step < 16`. There is no path through the code where a request is
  accepted mid-division.
- **No explicit state enum.** The step counter *is* the state, with one value borrowed
  to mean idle. Fewer things to keep consistent.
- **The mutual exclusion is proved, not asserted.** `bsc` checks that `start` and
  `iterate` cannot both fire. In Verilog you convince yourself by reading.
- **Compared with problem 21**: you wrote the sequencing by hand and it is longer. What
  you got is a machine that is a set of independently-guarded rules — so adding "abort
  on request" or "accept a new operand mid-flight" is a new rule, not a restructuring
  of a `seq`.

## How you're checked

60 divisions, with `65535 / 1` forced on round 0 — the widest quotient, which catches
a shift that drops the top bit. The reference just uses `/` and `%`. A machine that
never finishes trips the watchdog.

## Run it

```
Run
```
