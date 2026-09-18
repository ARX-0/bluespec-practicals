# Solution — 36

```bsv
   Reg #(Bit #(8)) r <- mkReg (0);

   rule tick;
      if (r == 9)
         r <= 0;
      else
         r <= r + 1;
   endrule

   method Bit #(8) count ();
      return r;
   endmethod
```

or, identically, with the rule body written as one assignment:

```
   rule tick;
      r <= (r == 9) ? 0 : r + 1;
   endrule
```

The rule has no condition of its own, so it fires on every single cycle. `r` is
written every cycle too — sometimes with `0`, sometimes with `r + 1`.

Hold on to that sentence, because problem 37 changes exactly one word of it: the
rule stops firing at all, and then the register is *not written*. Same-looking
code, different hardware, and the difference is where the condition goes.
