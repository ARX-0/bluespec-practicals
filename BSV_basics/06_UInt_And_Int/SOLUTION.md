# Solution — 06

```bsv
method UInt #(8) sumU (UInt #(8) a, UInt #(8) b);  return a + b;  endmethod
method Bool lessU (UInt #(8) a, UInt #(8) b);      return a < b;  endmethod
method Bool lessS (Int #(8) a, Int #(8) b);        return a < b;  endmethod
```

`lessU` and `lessS` have byte-for-byte identical source and produce **different
hardware**: an unsigned magnitude comparator and a signed one. The argument type
picked the circuit.

Adders are the opposite case — `a + b` is the same gates for `UInt` and `Int`,
because two's complement addition does not care. Comparison and shift-right do
care, which is why the type has to exist.
