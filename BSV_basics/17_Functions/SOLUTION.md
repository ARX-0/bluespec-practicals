# Solution — 17

Package level, above the interface:

```bsv
function Bit #(8) doubleIt (Bit #(8) x);
   return x << 1;
endfunction
```

Module body:

```bsv
   method Bit #(8) twiceSum (Bit #(8) a, Bit #(8) b);
      return doubleIt (a) + doubleIt (b);
   endmethod

   method Bit #(8) quad (Bit #(8) a);
      return doubleIt (doubleIt (a));
   endmethod
```

Three calls, three separate shifters — and since a shift by a constant is pure
rewiring, three times zero gates.

`quad` is the point worth keeping: `doubleIt (doubleIt (a))` composes at
elaboration time into one expression. Depth in the source becomes depth in the
combinational path, never cycles.
