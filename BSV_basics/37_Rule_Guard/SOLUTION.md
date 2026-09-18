# Solution — 37

```bsv
   Reg #(Bit #(8)) r <- mkReg (0);

   rule bump (r < 10);
      r <= r + 1;
   endrule

   method Bit #(8) count ();
      return r;
   endmethod
```

The counter settles at **10**, not 9: when `r` is 9 the guard is true, so the rule
fires once more and writes 10; at 10 the guard is false and the rule never fires
again. Off-by-one questions about guards are always answered this way — ask what
the last value that satisfies the guard writes.

`r <= r + 1;` never had to change. The guard is bolted on outside the behaviour,
which is why it composes: you can add a condition to a rule without touching what
it does.

Once `r` reaches 10 this design has a rule that can never fire again. That is
fine and intended here. But when a rule you *expected* to fire never does, `bsc`
often warns "rule can never fire" at compile time — that warning is the single
most useful diagnostic in the language, and BSVbits problem 08 is built entirely
around reading it.
