# Solution — 03

```bsv
method Bit #(4) andOp (Bit #(4) a, Bit #(4) b);  return a & b;  endmethod
method Bit #(4) orOp  (Bit #(4) a, Bit #(4) b);  return a | b;  endmethod
method Bit #(4) xorOp (Bit #(4) a, Bit #(4) b);  return a ^ b;  endmethod
method Bit #(4) notOp (Bit #(4) a);              return ~a;     endmethod
```

(A whole method fits on one line when the body is one statement — that is
ordinary style, not a trick.)

These are the same four gates you would write in Verilog. The one thing BSV adds
is width checking: `a & b` where `a` is `Bit#(4)` and `b` is `Bit#(8)` is a type
error, not a silent zero-extension.
