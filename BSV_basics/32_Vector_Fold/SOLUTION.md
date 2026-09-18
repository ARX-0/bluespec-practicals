# Solution — 32

Package level:

```bsv
function Bool isNonZero (Bit #(8) x) = x != 0;
```

Module body:

```bsv
method Bit #(8) total (Vector #(4, Bit #(8)) v);
   return fold (\+ , v);
endmethod

method Bit #(8) biggest (Vector #(4, Bit #(8)) v);
   return fold (max, v);
endmethod

method Bool allNonZero (Vector #(4, Bit #(8)) v);
   return fold (\&& , map (isNonZero, v));
endmethod
```

`allNonZero` is the pattern worth keeping: **`map` to turn each element into the
thing you care about, `fold` to combine them.** Reductions, priority checks,
"is anything ready?", "are all the FIFOs empty?" — all of them are this.

The space in `\+ ` and `\&& ` matters: without it the parser keeps reading the
operator. If you get a parse error on a fold, that is usually why.

Each of these is a two-deep tree of four-input logic — 32 wires in, 8 or 1 out,
all in one cycle.
