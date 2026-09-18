# Solution — 10

```bsv
method Bit #(4) low4 (Bit #(8) a);    return truncate (a);     endmethod
method Bit #(8) low8 (Bit #(16) a);   return truncate (a);     endmethod
method Bit #(4) high4 (Bit #(8) a);   return truncateLSB (a);  endmethod
```

`high4` could also be written `a[7:4]` (problem 11). The difference is that
`truncateLSB` does not name any index, so it still means "the top nibble" after
someone widens the argument to `Bit#(16)` — whereas `a[7:4]` silently becomes
the wrong nibble.

Prefer the width-relative form when you mean "the top of this value", and
explicit indices when you mean "these specific bits of this specific layout".
