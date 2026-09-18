# Solution — 16

Only if dire.

---

```bsv
   FIFOF #(Bit #(8)) inF  <- mkFIFOF;
   FIFOF #(Bit #(8)) outF <- mkFIFOF;

   rule move;
      let x = inF.first;
      inF.deq;
      outF.enq (x + 1);
   endrule

   method Action enq (Bit #(8) x);
      inF.enq (x);
   endmethod

   method ActionValue #(Bit #(8)) deq ();
      outF.deq;
      return outF.first;
   endmethod

   method Bool notFull ()  = inF.notFull;
   method Bool notEmpty () = outF.notEmpty;
```

Twelve lines, against roughly forty for the hand-built version in problem 13 — and
this one has a transform stage the other did not.

## Why it is written this way

**`rule move` has no condition and needs none.** It calls `inF.first`, `inF.deq` and
`outF.enq`, each of which is guarded. `bsc` ANDs all three readiness conditions into
the rule's firing condition. The rule fires exactly when there is something to move
and somewhere to put it, and the code says nothing about either.

This is problem 13's lesson arriving as a practical convenience rather than a
principle.

**The methods do not check anything either.** `method Action enq (Bit#(8) x); inF.enq(x); endmethod` inherits `inF`'s guard, so `RDY_enq` on the generated module is
`inF`'s not-full signal. Writing `if (inF.notFull)` yourself would be redundant at
best; at worst you would write a *different* condition and create a real bug.

**Why `mkFIFOF` and not `mkFIFO`.** The interface has to expose `notFull`/`notEmpty`
as readable values, and only `FIFOF` provides them. If the interface had only `enq`
and `deq`, plain `FIFO` would do — and in real BSV that is the common case, because
callers rely on guards rather than asking.

**Two FIFOs rather than one.** With one FIFO you would have to apply the transform
in `enq` or in `deq`, which works (it is what `.check/Ref.bsv` does) but fuses the
transform to the interface. Two FIFOs with a rule between them is a *stage*: the
work happens in the rule, and the rule can later become slower, guarded, or
multi-cycle without touching the interface. That is the shape problems 19 and 20
build on.

**Choosing between the variants.** For this problem `mkFIFOF` is right — you want
buffering and neither zero-latency nor same-cycle-when-full behaviour. Reach for
`mkPipelineFIFO` when you want a pipeline register that does not add a
combinational path, and `mkBypassFIFO` when a value must be usable the cycle it
arrives. Both cost something; the default is the right default.

## What to take forward

From here on, **the FIFO is the unit of composition in BSV**. Modules do not call
each other directly; they enqueue into each other's FIFOs and let the guards handle
the rest. A design built this way has no flow-control logic anywhere, and adding a
stage in the middle does not disturb anything on either side.

Problem 17 shows what that buys when the two ends run at different speeds.
