# Solution — 17

Only if dire.

---

```bsv
   FIFOF #(Bit #(8))  q     <- mkFIFOF;
   FIFOF #(Bit #(16)) outQ  <- mkFIFOF;
   Reg #(Bit #(8))    nextV <- mkReg (0);
   Reg #(Bit #(2))    phase <- mkReg (0);

   rule produce;
      q.enq (nextV);
      nextV <= nextV + 1;
   endrule

   rule tick;
      phase <= phase + 1;
   endrule

   rule consume (phase == 0);
      let x = q.first;
      q.deq;
      Bit #(16) w = zeroExtend (x);
      outQ.enq (w * w);
   endrule

   method ActionValue #(Bit #(16)) result ();
      outQ.deq;
      return outQ.first;
   endmethod

   method Bool hasResult () = outQ.notEmpty;
```

Count the flow-control expressions. There are none.

## Why it is written this way

**`q.enq(nextV)` and `nextV <= nextV + 1` must be in the same rule.** This is the
whole problem, and it is the thing that is hard to get right in Verilog.

The producer is four times faster than the consumer, so `q` fills almost
immediately and `produce` spends most of its life unable to fire. Because a rule is
**atomic**, "unable to fire" means neither action happens: no enqueue, and no
increment. The counter and the queue stay consistent for free.

Now imagine splitting them, as the Verilog structure encourages:

```bsv
rule count;                      // WRONG
   nextV <= nextV + 1;
endrule

rule push;                       // WRONG
   q.enq (nextV);
endrule
```

`count` is unguarded, so it advances every cycle regardless. `push` only fires when
there is room. The result is that three out of every four values are never
enqueued — the sequence out becomes 0, 4, 8, 12, … and the checker fails on result 1.
The bug is not in either rule; it is in the decision to separate them.

**`tick` *is* separate, deliberately.** The phase counter must keep running whether
or not the producer can enqueue — it is the consumer's clock divider, not part of
the producer's state. Splitting rules is right when the actions are genuinely
independent and wrong when they must stall together. That judgement is the skill.

**`zeroExtend` before the multiply.** `x * x` in `Bit#(8)` overflows for x ≥ 16 and
the sequence goes wrong at result 16. Widen first (problem 03).

**`consume` has two conditions and you wrote one.** The rule fires when `phase == 0`
**and** `q` is non-empty **and** `outQ` has room. The last two came from the FIFOs.

## What to take forward

**The atomicity of a rule is what makes automatic backpressure safe.** Guards alone
would not be enough: if a stalling stage could partially execute, a stalled pipeline
would corrupt itself. Because a rule is all-or-nothing, "this stage cannot proceed"
is a complete and consistent statement about all of its state at once.

That is the answer to "why is BSV's stalling correct and my Verilog pipeline's
stalling buggy". In Verilog, the enable must be routed to every register in the
stage, by hand, every time. In BSV the stage is one rule and there is nothing to
route.

The practical rule of thumb: **put actions that must stall together in the same rule,
and actions that must proceed independently in different rules.** Nearly every
scheduling bug in a BSV design is that line drawn in the wrong place.
