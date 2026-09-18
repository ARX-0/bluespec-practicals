# Solution — 31

Package level:

```bsv
function Bit #(8) doubleIt (Bit #(8) x) = x << 1;
function Bool     isNonZero (Bit #(8) x) = x != 0;
```

Module body:

```bsv
   method Vector #(4, Bit #(8)) doubleAll (Vector #(4, Bit #(8)) v);
      return map (doubleIt, v);
   endmethod

   method Vector #(4, Bool) nonZero (Vector #(4, Bit #(8)) v);
      return map (isNonZero, v);
   endmethod
```

Four shifters and four comparators — one per element, all combinational, all in
the same cycle.

`nonZero` shows the type change: the input is a vector of `Bit#(8)`, the output a
vector of `Bool`, and the length stays 4 because `map` preserves it. Nothing in
the source says 4; widen the vector to 8 elements and both methods still say
exactly this.
