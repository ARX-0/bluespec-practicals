# Solution — 42

```bsv
   FIFOF #(Bit #(8)) f   <- mkSizedFIFOF (4);
   Reg #(Bit #(8))   acc <- mkReg (0);

   rule drain;
      acc <= acc + f.first;
      f.deq;
   endrule

   method Action push (Bit #(8) x);
      f.enq (x);
   endmethod

   method Bit #(8) total ();
      return acc;
   endmethod
```

Two lines, no condition, and it is correct on an empty queue — because `f.first`
and `f.deq` both carry `notEmpty`, and a rule's guard is the AND of its own
condition with every implicit condition it inherits.

`push` gets the same treatment from the other side: it calls `f.enq`, which is
only ready when the queue has room, so `push` itself becomes **unready** when the
FIFO is full. A caller's rule then cannot fire, and the backpressure has
propagated one level up without anyone designing it.

That is the property the whole language is built around, and it is why BSVbits
spends problems 13 and 16–20 on it. From here, the ladder in `BSVbits/` will read
as combinations of things you have seen rather than new ideas.
