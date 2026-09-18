# Solution — 18

Only if dire.

---

```bsv
module mkAddOne (Stage_IFC #(Bit #(8), Bit #(8)));
   FIFOF #(Bit #(8)) inQ  <- mkFIFOF;
   FIFOF #(Bit #(8)) outQ <- mkFIFOF;

   rule go;
      let x = inQ.first;
      inQ.deq;
      outQ.enq (x + 1);
   endrule

   interface inp  = toPut (inQ);
   interface outp = toGet (outQ);
endmodule

module mkTimesThree (Stage_IFC #(Bit #(8), Bit #(16)));
   FIFOF #(Bit #(8))  inQ  <- mkFIFOF;
   FIFOF #(Bit #(16)) outQ <- mkFIFOF;

   rule go;
      let x = inQ.first;
      inQ.deq;
      Bit #(16) w = zeroExtend (x);
      outQ.enq (w * 3);
   endrule

   interface inp  = toPut (inQ);
   interface outp = toGet (outQ);
endmodule
```

and `mkTop`:

```bsv
   Stage_IFC #(Bit #(8), Bit #(8))  a <- mkAddOne;
   Stage_IFC #(Bit #(8), Bit #(16)) b <- mkTimesThree;

   mkConnection (a.outp, b.inp);

   interface request  = a.inp;
   interface response = b.outp;
```

## Why it is written this way

**`mkConnection (a.outp, b.inp)` is the entire integration.** No wires named, no
handshake matched, no rule written. And crucially it is the *same line* regardless
of what `a` and `b` are — swap `mkAddOne` for a cache, a serialiser, or a bus
adapter and the connection does not change. That is what standard interfaces buy;
the names `get` and `put` are doing all the work.

**`toPut (inQ)` rather than writing the method out.** These two are identical:

```bsv
interface inp = toPut (inQ);
```
```bsv
interface Put inp;
   method Action put (Bit #(8) x);
      inQ.enq (x);
   endmethod
endinterface
```

The adapter is preferred because it cannot drift: if the FIFO changes, the adapter
still does the right thing. Use `toGet`/`toPut` whenever the interface is exactly a
FIFO end, which is most of the time.

**`interface request = a.inp;` — handing a subinterface straight through.** `mkTop`
implements nothing of its own; it wires the outer ends of the chain to its own
interface. This is extremely common in BSV: a top-level module is often just
instantiation plus connection plus a few of these pass-through lines.

**Each stage owns FIFOs on both sides.** `mkConnection` moves items between `a`'s
output FIFO and `b`'s input FIFO, so there are two buffers at the seam. That is
mildly wasteful and completely standard — it keeps the stages independently
designable, and it is why you can insert a stage anywhere without disturbing its
neighbours. If the buffering matters, `mkConnection` between a `Get` and a `Put`
that are not FIFO-backed costs nothing extra.

**Why not just call `b.inp.put(...)` from `a`'s rule?** Because then `a` would have
to know about `b`. The stages stay ignorant of each other and the topology lives in
one place, in `mkTop`, where you can read it.

## What to take forward

`Get` and `Put` are the interfaces you should reach for by default whenever a module
produces or consumes a stream of values. The payoff compounds:

- anything can be connected to anything with `mkConnection`
- the library's adapters (`toGet`, `toPut`, `mkConnection` for `FIFOF`s) work on
  your modules for free
- test benches can drive any `Put` and drain any `Get` without knowing the module

Problem 20 pairs them into `Client` and `Server` for request/response traffic, which
is the shape of every memory interface and every bus protocol — AXI included.
