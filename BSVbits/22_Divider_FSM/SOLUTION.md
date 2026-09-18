# Solution — 22

Only if dire.

---

```bsv
   Reg #(Bit #(16))   quo   <- mkReg (0);
   Reg #(Bit #(16))   rem   <- mkReg (0);
   Reg #(Bit #(8))    den_r <- mkReg (0);
   Reg #(Bit #(5))    step  <- mkReg (16);      // 16 == idle
   FIFOF #(DivResult) outQ  <- mkFIFOF;

   rule iterate (step < 16);
      Bit #(16) r2 = (rem << 1) | zeroExtend (quo[15]);
      Bit #(16) q2 = quo << 1;

      Bit #(16) d = zeroExtend (den_r);
      if (r2 >= d) begin
         r2 = r2 - d;
         q2 = q2 | 1;
      end

      if (step == 15) begin
         outQ.enq (DivResult { quo: q2, rem: r2 });
         step <= 16;
      end
      else begin
         quo  <= q2;
         rem  <= r2;
         step <= step + 1;
      end
   endrule

   method Action start (Bit #(16) num, Bit #(8) den) if (step == 16);
      quo   <= num;
      rem   <= 0;
      den_r <= den;
      step  <= 0;
   endmethod

   method ActionValue #(DivResult) result ();
      outQ.deq;
      return outQ.first;
   endmethod
```

## Why it is written this way

**Locals with `=`, registers with `<=`, and the two do different things.** `r2` and
`q2` are combinational values: the `if` can subtract from `r2` and see the result
immediately, because there is no clock edge involved. Had they been registers, the
`if` would have been reasoning about stale values and the conditional subtract would
be a cycle late.

This split — compute the whole next state combinationally into locals, then commit it
with one set of `<=` writes — is the standard shape of a datapath rule in BSV, and it
is worth adopting as a habit. It keeps the "what is the next state" logic in one
readable block and the "when does it land" question trivial.

**Publish `q2`/`r2`, not `quo`/`rem`.** On the final step the registers still hold the
pre-iteration values. Enqueueing them loses the last iteration — and only the last, so
the quotient comes out halved-ish and it looks like a shift bug rather than an
ordering bug. Same trap as problem 20's `nextProd`.

**`step == 16` as the idle marker.** It makes `start`'s guard and `iterate`'s guard
mutually exclusive, so `bsc` proves the two rules never conflict despite both writing
`step`. If you had used a separate `Bool busy` register you would have the same
behaviour and one more thing to keep in sync.

**The dividend starts in `quo`.** This is the part of restoring division that looks
wrong the first time. `quo` initially holds the dividend; each cycle its top bit
shifts into `rem` and a quotient bit shifts in at the bottom. After 16 cycles the
dividend has been entirely consumed and the quotient has entirely replaced it. One
register does two jobs at different times.

**Widths.** `rem` never exceeds 255 (it is always below `den`, which is 8 bits), so
`rem << 1` is below 512 and 16 bits is generous. If `den` were widened to 16 bits, the
shifted remainder would need **17** — a genuine overflow that random small operands
would never expose. The forced `65535 / 1` case on round 0 exists to catch the
related mistake on the quotient side.

## What to take forward

**Compare this against problem 21.** Same class of machine, two very different sources:

| | `StmtFSM` (21) | hand-written (22) |
|---|---|---|
| control flow | reads as the algorithm | reconstructed from guards |
| length | shorter | longer |
| ordering | fixed by the `seq` | emerges from guards and data |
| reacting to outside events mid-flight | awkward | natural — add a rule |
| interruption, elasticity | hard | a guard |

Neither is the right default. The question to ask is **whether the sequence is fixed**.
An initialisation routine or a test sequence is fixed — use `StmtFSM`. A unit that
must accept aborts, handle whichever input arrives first, or stall elastically is not
— use guarded rules.

Most real designs contain both, and the boundary between them is usually the boundary
between "the protocol" and "the algorithm".
