# Solution — 30

```bsv
method Vector #(4, Bit #(8)) allSame (Bit #(8) x);
   return replicate (x);
endmethod

method Vector #(4, Bit #(8)) setOne (Vector #(4, Bit #(8)) v,
                                     Bit #(2) idx, Bit #(8) x);
   return update (v, idx, x);
endmethod

method Vector #(4, Bit #(8)) onlyFirst (Bit #(8) x);
   return update (replicate (0), 0, x);
endmethod
```

In `onlyFirst` the index is the constant `0`, so nothing is built: `bsc`
elaborates the whole expression away into "x on the first eight wires, zeros on
the rest". In `setOne` the index is a run-time value, so real select logic
appears. Same function, and the cost is decided by what you pass it.

`replicate (0)` needs no length — the return type says four.
