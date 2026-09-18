# Solution — 39

```bsv
   Reg #(Bit #(8)) next <- mkReg (0);

   method ActionValue #(Bit #(8)) take ();
      next <= next + 1;
      return next;
   endmethod

   method Bit #(8) peek ();
      return next;
   endmethod
```

The order of the two lines does not matter. `return next` reads the current value
and `next <= next + 1` schedules the new one for the next cycle, so writing them
the other way round gives the identical hardware. Rule bodies are not sequential
statements — they all describe one cycle.

`peek` returns the same value `take` would, without the increment. Having both is
common and worth noticing: it lets a caller decide based on the value before
committing to consume it. That is precisely the `first` / `deq` split on a FIFO,
which is problem 41.
