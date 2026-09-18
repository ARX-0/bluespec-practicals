# Solution — 19

Only if dire.

---

```bsv
   FIFOF #(Bit #(8))  q0 <- mkFIFOF;   // input
   FIFOF #(Bit #(8))  q1 <- mkFIFOF;   // after stage 1
   FIFOF #(Bit #(16)) q2 <- mkFIFOF;   // after stage 2
   FIFOF #(Bit #(16)) q3 <- mkFIFOF;   // output

   rule stage1;
      let x = q0.first;
      q0.deq;
      q1.enq (x + 1);
   endrule

   rule stage2;
      let x = q1.first;
      q1.deq;
      Bit #(16) w = zeroExtend (x);
      q2.enq (w * 3);
   endrule

   rule stage3;
      let x = q2.first;
      q2.deq;
      q3.enq (x ^ 16'hAAAA);
   endrule

   method Action put (Bit #(8) x);
      q0.enq (x);
   endmethod

   method ActionValue #(Bit #(16)) get ();
      q3.deq;
      return q3.first;
   endmethod

   method Bool canPut () = q0.notFull;
   method Bool canGet () = q3.notEmpty;
```

## Why it is written this way

**Every stage is identical in shape and independent in operation.** Each fires when
its input has something and its output has room. No stage knows the others exist.
That independence is what makes the pipeline elastic: a stall anywhere backs up one
stage per cycle and clears the same way, with no coordination.

**All four rules and both methods fire in the same cycle at full rate.** `put` writes
`q0`, `stage1` reads `q0` and writes `q1`, `stage2` reads `q1` and writes `q2`,
`stage3` reads `q2` and writes `q3`, `get` reads `q3`. Six operations, four
different items in flight, one cycle. Nothing had to be scheduled by hand because no
two of them touch the same FIFO end.

**Latency 3, throughput 1 per cycle.** The FIFOs are what separate these. A rigid
Verilog pipeline achieves the same throughput but cannot stall; making it stallable
is where the work is.

**Stage 1 wraps at 255, deliberately.** `x + 1` on `Bit#(8)` gives 0 for x = 255, and
the specification says stage 1 is 8 bits wide. Widening early would produce 768
instead of 0 at stage 2 and fail the check. When a pipeline's intermediate widths are
part of the spec, they are part of the behaviour — this is exactly the kind of
detail that gets lost in Verilog and is checked here.

*(This one is not hypothetical: the first version of this problem's reference
computed the whole chain in 16 bits while the stages were specified as 8, and the
checker caught the disagreement on the one input in 256 that exposes it.)*

**`mkFIFOF` at every seam is the safe default, not the cheap one.** Four 2-deep FIFOs
is more storage than four pipeline registers. If you know stage 2 can never stall,
`mkPipelineFIFO` gives you the register-like cost with the FIFO interface. Reach for
that as an optimisation, once the design works and you have a reason.

## What to take forward

This is the standard shape of a BSV datapath, and it scales without changing:

```
put → [FIFO] → rule → [FIFO] → rule → [FIFO] → rule → [FIFO] → get
```

Every stage is `first`/`deq`/`enq` and its own arithmetic. Adding a stage is a local
edit. Making a stage multi-cycle (problem 20) or variable-latency does not disturb
its neighbours — they see a FIFO either way.

When you build a CPU later, the fetch/decode/execute/writeback structure is this,
with the FIFOs carrying instruction records instead of integers. The hazards are the
interesting part; the pipeline plumbing is what you just wrote.
