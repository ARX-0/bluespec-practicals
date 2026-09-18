# Solution — 14

```bsv
method Bit #(2) band (Bit #(8) x);
   if      (x < 8'd10)  return 0;
   else if (x < 8'd100) return 1;
   else                 return 2;
endmethod

method Int #(8) signOf (Int #(8) x);
   if      (x < 0) return -1;
   else if (x > 0) return 1;
   else            return 0;
endmethod
```

The chain is a **priority** structure: the second test only matters when the
first was false, which is why `x < 100` does not need an `x >= 10` alongside it.
Writing both would generate the same hardware and read worse.

`signOf` returns `-1` directly because the return type is `Int#(8)`. On a
`Bit#(8)` return you would have to write `8'hFF` and mean it.
