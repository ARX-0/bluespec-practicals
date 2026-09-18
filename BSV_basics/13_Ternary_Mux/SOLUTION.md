# Solution — 13

```bsv
method Bit #(8) mux2 (Bool sel, Bit #(8) a, Bit #(8) b);
   return sel ? b : a;
endmethod

method Bit #(8) mux2b (Bit #(1) sel, Bit #(8) a, Bit #(8) b);
   return (sel == 1) ? b : a;
endmethod

method Bit #(8) maxOf (Bit #(8) a, Bit #(8) b);
   return (a > b) ? a : b;
endmethod
```

`mux2b` is the only one that needs the `== 1`, and that comparison generates no
hardware — it is a `Bit#(1)` being renamed a `Bool`. `pack`/`unpack` (problem 07)
would do the same job: `unpack (sel) ? b : a`.

In `maxOf`, `a > b` is already a `Bool`, so no conversion appears at all. Get
used to reading conditions as "does this produce a `Bool`?" — it is how the type
errors in the next few problems will read.
