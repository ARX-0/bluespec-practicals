# Solution — 20

Only if dire.

---

```bsv
   Reg #(Bit #(16))   prod  <- mkReg (0);
   Reg #(Bit #(16))   mcand <- mkReg (0);
   Reg #(Bit #(8))    mplr  <- mkReg (0);
   Reg #(Bit #(4))    step  <- mkReg (8);      // 8 == idle
   FIFOF #(Bit #(16)) outQ  <- mkFIFOF;

   rule iterate (step < 8);
      Bit #(16) nextProd = (mplr[0] == 1) ? prod + mcand : prod;

      mcand <= mcand << 1;
      mplr  <= mplr >> 1;

      if (step == 7) begin
         outQ.enq (nextProd);      // last step: hand the result over
         step <= 8;                // and go idle
      end
      else begin
         prod <= nextProd;
         step <= step + 1;
      end
   endrule

   interface Server srv;
      interface Put request;
         method Action put (MulReq r) if (step == 8);
            prod  <= 0;
            mcand <= zeroExtend (r.a);
            mplr  <= r.b;
            step  <= 0;
         endmethod
      endinterface

      interface response = toGet (outQ);
   endinterface
```

## Why it is written this way

**`nextProd` as a local, not `prod <= prod + mcand`.** On the final step you need the
completed product *this cycle*, to enqueue it. But `<=` does not land until the clock
edge, so `prod` still holds the pre-add value everywhere in this rule. Computing
`nextProd` first and using it for both the enqueue and the (non-final) register write
is the fix. Writing `prod <= prod + mcand; outQ.enq (prod);` enqueues a value one
add short — and only on the last step, so it is wrong for every multiply whose top
multiplier bit is set. Exactly the kind of bug the forced `255 × 255` case catches.

**`step == 8` as the idle marker.** It makes `put`'s guard (`step == 8`) and
`iterate`'s guard (`step < 8`) provably mutually exclusive, so `bsc` knows the two
never fire together despite both writing `step`. No `descending_urgency` needed
(problem 08) — the guards did the work. Encoding "idle" as an out-of-range value of
the counter you already have is a common and tidy BSV idiom.

**The result goes through `outQ`.** Returning `prod` from `response.get` directly
would compile and would pass this testbench, and it would be wrong: `get` would be
ready even before the first request, handing out a stale or reset value. Routing
through a FIFO makes "a result exists" the guard, which is the honest statement.
It also decouples the unit from the consumer — the multiplier can start the next
job while the last result waits to be collected.

**`mcand` is 16 bits, `mplr` is 8.** The multiplicand shifts left up to seven places
and must not lose the top bits; the multiplier only ever shifts right. Getting this
backwards gives correct answers for small inputs and wrong ones for large — which is
why the checker forces `255 × 255` on round 0 rather than trusting random stimulus
to find it.

**`interface response = toGet (outQ);`** — one line instead of a method. Same
reasoning as problem 18.

## What to take forward

**This is the shape of every long-latency component you will ever write in BSV:**

```
request  (guarded on being able to accept)
   ↓
  work, over as many cycles as it takes
   ↓
response (guarded on a result existing)
```

Memory ports, cache lookups, dividers, floating-point units, bus transactions. The
caller does `put` then `get` and never knows the latency. Change 8 cycles to 40 and
nothing upstream is affected.

`Server` and `Client` are also where the AXI work later starts: an AXI4-Lite slave is
a `Server#(AXI4L_Req, AXI4L_Resp)` once you have defined the request and response
structs (problem 04), and an AXI4 master is the corresponding `Client`. The five AXI
channels are five of these, and `mkConnection` joins a master to a slave in one line.

You now have every BSV mechanism needed to build one.
