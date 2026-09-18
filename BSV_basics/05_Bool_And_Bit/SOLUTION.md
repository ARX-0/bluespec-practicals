# Solution — 05

```bsv
method Bool isEqual (Bit #(8) a, Bit #(8) b);  return a == b;  endmethod
method Bool bothTrue (Bool p, Bool q);         return p && q;  endmethod
method Bool notP (Bool p);                     return ! p;     endmethod
```

`a == b` already *is* a `Bool`, so there is nothing to convert — writing
`(a == b) ? True : False` is the same thing said twice.

In the generated Verilog a `Bool` is one wire, the same wire a `Bit#(1)` would
be. The separation exists in the type system, not in the hardware.
