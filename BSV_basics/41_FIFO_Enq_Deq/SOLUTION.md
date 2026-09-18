# Solution — 41

```bsv
   FIFOF #(Bit #(8)) f <- mkSizedFIFOF (4);

   method Action push (Bit #(8) x);
      f.enq (x);
   endmethod

   method ActionValue #(Bit #(8)) pop ();
      f.deq;
      return f.first;
   endmethod

   method Bool empty ();
      return ! f.notEmpty;
   endmethod

   method Bool full ();
      return ! f.notFull;
   endmethod
```

`pop` is an `ActionValue` (problem 39) because it does both jobs at once — that is
exactly the case `ActionValue` exists for.

The order of `f.deq;` and `return f.first;` does not matter, for the reason given
in problem 40: `f.first` reads the queue's state at the start of the cycle, and
`f.deq` changes it for the next one.

`empty` and `full` are value methods, so a caller can ask without committing to
anything. Problem 42 is about why you usually should not have to.
