# Solution — 09

```bsv
method Bit #(8) sext (Bit #(4) a);    return signExtend (a);  endmethod
method Bit #(8) zext (Bit #(4) a);    return zeroExtend (a);  endmethod
method Int #(16) sextI (Int #(8) a);  return signExtend (a);  endmethod
```

Compare `sext` and `zext`: same input type, same output type, different circuit.
On `Bit#(n)` the compiler cannot pick for you, because `Bit#(n)` is just wires.

`Int#(n)` *does* carry the answer, which is why there is a third function,
`extend` — it zero-extends unsigned types and sign-extends signed ones. So
`sextI` could be written `return extend (a);` and mean the same thing. Naming the
behaviour you want is still clearer at a call site.
