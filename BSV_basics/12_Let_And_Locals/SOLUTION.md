# Solution — 12

```bsv
method Bit #(8) mix (Bit #(8) a, Bit #(8) b);
   let sum  = a + b;
   let diff = a - b;
   return sum ^ diff;
endmethod

method Bit #(8) avg (Bit #(8) a, Bit #(8) b);
   Bit #(9) wide = zeroExtend (a) + zeroExtend (b);
   return truncate (wide >> 1);
endmethod
```

In `mix`, `let` is right: the type of `a + b` is not in question.

In `avg` it would be wrong. The whole point is that the sum is **nine** bits, so
the width is the idea being expressed and belongs in the source. Writing
`let wide = a + b;` gives you an eight-bit sum and the bug back.

That is the rule of thumb: `let` for plumbing, an explicit type wherever the
width is the decision.
