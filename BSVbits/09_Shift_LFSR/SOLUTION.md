# Solution — 09

Only if dire.

---

```bsv
   Reg #(Bit #(8))              s  <- mkReg (8'hFF);
   Vector #(3, Reg #(Bit #(1))) dl <- replicateM (mkReg (0));

   rule step;
      Bit #(1) nb = s[7] ^ s[5] ^ s[4] ^ s[3];
      s <= { s[6:0], nb };

      dl[0] <= s[0];
      for (Integer i = 1; i < 3; i = i + 1)
         dl[i] <= dl[i - 1];
   endrule

   method Bit #(8) lfsr     = s;
   method Bit #(1) delayed3 = dl[2];
```

## Why it is written this way

**One rule, not four.** Every write here happens unconditionally every cycle, and
they touch disjoint registers, so there is nothing to schedule and no reason to
split. Guarded rules earn their keep when things happen *sometimes*; this all
happens always.

**The order of the writes inside the rule is irrelevant.** `dl[0] <= s[0]` before
`dl[1] <= dl[0]` reads like a sequence, but `<=` is non-blocking: every right-hand
side is evaluated against the start-of-cycle state, and all the writes land
together. Reversing these three lines produces identical hardware. If they *were*
sequential you would have written a 1-deep line three times over.

**`for (Integer i ...)` costs nothing.** `bsc` unrolls it at compile time into
`dl[1] <= dl[0]; dl[2] <= dl[1];`. There is no loop in the hardware and no counter.
Writing it out by hand for 3 stages is fine; writing it out by hand for 64 is how
you get a typo, so build the habit now.

**`Vector#(3, Reg#(Bit#(1)))` rather than `Reg#(Bit#(3))`.** Compare with
`.check/Ref.bsv`, which packs the line into one register and shifts it with
`d <= {d[1:0], s[0]}`. That is shorter, and for this exact problem it is fine.
It stops being fine the moment any stage needs to behave differently from the
others — its own enable, its own tap, a bypass around it — because a packed
register has exactly one write and all three bits must be decided together. Three
registers have three writes.

This is the same trade as problem 05's `map` versus a bit loop: pick the
representation that keeps the parts separable, because the parts usually do
separate later.

## What to take forward

`replicateM` is how BSV builds *arrays of hardware*. You will use it for register
files, for a bank of FIFOs, for per-lane pipeline stages, for the state of a
multi-way cache. Whenever you would have written a Verilog `generate` loop, the BSV
version is `replicateM` plus an ordinary static `for`.

And remember the naming rule that comes with it: **an `M` on the end means it
instantiates hardware and needs `<-`.** `replicate`/`replicateM`, `map`/`mapM`,
`zipWith`/`zipWithM`.
