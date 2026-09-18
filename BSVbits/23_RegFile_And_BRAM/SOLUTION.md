# Solution — 23

Only if dire.

---

```bsv
   RegFile #(Bit #(4), Bit #(8)) rf <- mkRegFileFull;

   BRAM_Configure cfg = defaultValue;
   cfg.memorySize = 256;
   BRAM1Port #(Bit #(8), Bit #(8)) bram <- mkBRAM1Server (cfg);

   method Action rfWrite (Bit #(4) a, Bit #(8) d);
      rf.upd (a, d);
   endmethod

   method Bit #(8) rfRead (Bit #(4) a) = rf.sub (a);

   method Action rfBramWrite (Bit #(8) a, Bit #(8) d);
      bram.portA.request.put (BRAMRequest {
         write:           True,
         responseOnWrite: False,
         address:         a,
         datain:          d });
   endmethod

   method Action bramReadReq (Bit #(8) a);
      bram.portA.request.put (BRAMRequest {
         write:           False,
         responseOnWrite: False,
         address:         a,
         datain:          0 });
   endmethod

   method ActionValue #(Bit #(8)) bramReadResp ();
      let d <- bram.portA.response.get ();
      return d;
   endmethod
```

## Why it is written this way

**`rfRead` is a value method and `bramReadResp` is an `ActionValue`, and that
difference is the entire problem.** A combinational read is a function of current
state — it changes nothing, so it is a value method, and callers get the answer in
the same expression. A BRAM read takes a cycle, so it *must* be split: the request
changes state (a read is now in flight) and the response consumes it.

You cannot write a BSV interface that pretends a BRAM read is combinational. The
latency is a fact about the hardware and it surfaces in the method kinds.

**`responseOnWrite: False`.** With `True`, every write also enqueues a response, and
since reads and writes share one response queue, your read responses would come back
interleaved with meaningless write acknowledgements. Almost always `False` unless you
specifically need write completion ordering.

**One request port, both operations.** `BRAMRequest` carries a `write` flag rather
than there being separate read and write methods. That mirrors real block RAM, where
a port does one thing per cycle, and it is why `rfBramWrite` and `bramReadReq` in this
module conflict — they both call `request.put`. The testbench does them on separate
cycles.

**Both memories start uninitialised, and the checker had to be built around it.**
`mkRegFileFull` and `mkBRAM1Server` take no reset value. Reading an address never
written returns something arbitrary — in Bluesim, a fixed pattern; in silicon,
whatever the RAM powered up with. The testbench therefore writes all 256 BRAM and all
16 RegFile locations before reading any of them.

*(This is not hypothetical: the first version of this problem's reference modelled the
memories as registers reset to 0, and the very first read of an untouched address
disagreed. The preload phase is the fix, and it is what you would have to do in a real
testbench too.)*

**When to use which:**

| | `RegFile` | `BRAM` |
|---|---|---|
| read latency | 0 | 1 cycle |
| cost per entry | high (flops + mux) | low (dedicated RAM block) |
| good for | ≲ 64 entries: CPU register files, small tables | ≳ 256 entries: caches, buffers, main memory |
| interface | plain methods | `Server` — request/response |

The crossover is roughly where the read mux stops being cheaper than a RAM block, and
it depends on your target. A 32-entry RISC-V register file is a `RegFile`; a 4 KB
instruction cache is a `BRAM`.

## What to take forward

**Latency determines interface shape.** Zero-latency things get value methods.
Anything with latency becomes request/response — a `Server` — regardless of whether it
is a memory, a divider, a bus, or a floating-point unit.

That is why problem 20's multiplier and this problem's BRAM look the same from
outside, and it is why a design built on `Client`/`Server` can have its memory swapped
from a RegFile to a BRAM to a cache hierarchy with no change above.

Problem 24 builds a pipeline around this latency, which is the load-use problem in
miniature.
