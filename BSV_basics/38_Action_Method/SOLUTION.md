# Solution — 38

```bsv
   Reg #(Bit #(8)) r <- mkReg (0);

   method Action set (Bit #(8) x);
      r <= x;
   endmethod

   method Bit #(8) get ();
      return r;
   endmethod

   method Action add (Bit #(8) x);
      r <= r + x;
   endmethod
```

`add` reads `r` and writes `r` in one method, the same shape as the rule in
problem 34, and with the same meaning: the read sees the current value, the write
lands next cycle.

`set` and `add` both write `r`, so they can never be called in the same cycle.
`bsc` works that out and records it in the module's schedule — call both from one
rule and you get a conflict error naming the two methods. That is not a
restriction to work around; it is the compiler noticing that two writes to one
register in one cycle has no meaning.
