# Solution — 19

```bsv
method Bool isRed (Light l);                return l == RedLight;    endmethod
method Bool isGo (Light l);                 return l == GreenLight;  endmethod
method Bool sameLight (Light a, Light b);   return a == b;           endmethod
```

`sameLight` is the one to notice: `deriving (Eq)` generated a comparison for the
*whole type*, so comparing two `Light`s needs no per-value knowledge. When the
type is a struct with six fields (problem 21), the same `a == b` still works and
still costs one comparator per field.

Underneath, all three are equality on two bits. The type system is what stops you
writing `l == 2` or `l == Red`.
