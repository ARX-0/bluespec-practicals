# Solution — 07

```bsv
method Bit #(1) toBit (Bool p);          return pack (p);    endmethod
method Bool toBool (Bit #(1) b);         return unpack (b);  endmethod
method Bit #(8) uToBits (UInt #(8) u);   return pack (u);    endmethod
method UInt #(8) bitsToU (Bit #(8) b);   return unpack (b);  endmethod
```

`unpack` is *type-directed*: the two calls above are different functions, chosen
by what the method returns. Nowhere do you name `Bool` or `UInt#(8)` — and if
you change the interface, the same one-line body still compiles and still means
the right thing.

That is the property to carry forward. In problem 24 `unpack` will turn ten raw
bits into a struct with three named fields, and the body will still be
`return unpack (raw);`.
