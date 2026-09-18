# Solution — 23

```bsv
method Bit #(16) toBits (Header h);
   return pack (h);
endmethod

method Bit #(8) topByte (Header h);
   return truncateLSB (pack (h));
endmethod
```

`pack` on a struct is exactly `pack` on a `Bool` from problem 07 — the same
function, chosen by the type of its argument. It costs nothing: sixteen wires
being renamed.

`topByte` composes `truncateLSB` with `pack`, and neither call mentions 16, 8, or
15:8. Add a field to `Header` and this method still returns its top byte.
`pack(h)[15:8]` would still compile and would then be returning the wrong bits —
that is the failure mode index-free code avoids.
