# Solution — 04

```bsv
method Bit #(8) hexLit  ();  return 8'hF0;         endmethod
method Bit #(8) decLit  ();  return 8'd42;         endmethod
method Bit #(8) binLit  ();  return 8'b0000_1111;  endmethod
method Bit #(8) allOnes ();  return '1;            endmethod
method Bit #(8) zeros   ();  return 0;             endmethod
```

`'1` and `0` carry no width of their own; they take the width demanded by the
context, here the method's `Bit#(8)` return type. That is why `'1` is the right
way to write an all-ones mask: widen the type later and the constant follows.

Note `8'hF0` and `8'b1111_0000` are the same value — the base is notation, not
type.
