# Solution — 24

Only if dire.

---

```bsv
   BRAM_Configure cfg = defaultValue;
   cfg.memorySize = 256;
   BRAM1Port #(Bit #(8), Bit #(8)) bram <- mkBRAM1Server (cfg);

   FIFOF #(Bit #(8)) outQ <- mkSizedFIFOF (8);

   // The second half of every load: the answer arrives a cycle after the
   // request, on its own, and this rule finishes the job.
   rule collect;
      let d <- bram.portA.response.get ();
      outQ.enq (d + 1);
   endrule

   method Action writeMem (Bit #(8) a, Bit #(8) d);
      bram.portA.request.put (BRAMRequest {
         write:           True,
         responseOnWrite: False,
         address:         a,
         datain:          d });
   endmethod

   method Action load (Bit #(8) a);
      bram.portA.request.put (BRAMRequest {
         write:           False,
         responseOnWrite: False,
         address:         a,
         datain:          0 });
   endmethod

   method ActionValue #(Bit #(8)) loadResult ();
      outQ.deq;
      return outQ.first;
   endmethod
```

## Why it is written this way

**`collect` is a rule, and that is the answer to the problem.** A load is not one
event; it is a request now and an answer later. The request is caused by a caller, so
it is a method. The answer is caused by *the memory*, so it cannot be a method —
nobody is there to call one at the right moment. It has to be a rule that fires when
the response appears.

Once you see that, the load-use problem stops being about timing and becomes about
who initiates what. Anything initiated from outside is a method; anything initiated by
the design's own state is a rule.

**Why not collect inside `loadResult`.** The tempting version fuses the response
collection to the consumer's demand:

```bsv
method ActionValue #(Bit #(8)) loadResult ();     // WRONG
   let d <- bram.portA.response.get ();
   return d + 1;
endmethod
```

It passes a testbench that always collects promptly. It is wrong because responses
then only get pulled out of the BRAM when the consumer asks, so the memory's response
buffer backs up the moment the consumer pauses, and back-pressure reaches `load`
far earlier than it should. With the rule, finished loads accumulate in `outQ`
independently of what the consumer is doing.

The general principle: **do not make the arrival of data depend on someone asking for
it.** Pull it out as soon as it exists and buffer it.

**Results stay in order without any tracking.** A BRAM port returns responses in
request order, and a FIFO preserves order, so `loadResult` produces results matching
the sequence of `load` calls. There is no tag, no reorder buffer, no scoreboard —
because nothing here can complete out of order. (A multi-bank memory or a cache with
hits and misses *can*, and that is exactly when you need tags.)

**`mkSizedFIFOF(8)` for slack.** Depth 2 would work against this testbench.
A deeper output queue lets the producer side keep running while the consumer stalls,
which is the whole reason to decouple them. Size it to the longest stall you expect.

**`writeMem` and `load` conflict.** Both call `bram.portA.request.put`, and a BRAM
port does one thing per cycle. `bsc` schedules them as mutually exclusive; the
testbench preloads first and then only loads. A design needing simultaneous read and
write wants `mkBRAM2Port`.

## What to take forward

This is the CPU memory stage, in miniature. In a pipelined core:

- the execute stage issues the address — a method call, driven from outside
- a rule collects the data when it arrives and pushes it into the writeback queue
- the FIFO between them is what lets the front end keep fetching while a load is
  outstanding

Everything harder about real load-use — forwarding a loaded value to the very next
instruction, stalling when it is not ready yet, tracking multiple outstanding misses —
is built on this split, plus the CRegs from problem 10 for the forwarding paths.

You now have every mechanism that requires.
