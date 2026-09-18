# Solution — 27

```bsv
method Bool valid (Maybe #(Bit #(8)) m);              return isValid (m);       endmethod
method Bit #(8) orZero (Maybe #(Bit #(8)) m);         return fromMaybe (0, m);  endmethod
method Bit #(8) orElse (Maybe #(Bit #(8)) m, Bit #(8) d);
   return fromMaybe (d, m);
endmethod
```

`fromMaybe (d, m)` is a two-input multiplexer selected by the tag bit — the same
gates as `m.valid ? m.data : d` in a hand-rolled Verilog valid/data pair. What it
adds is that you cannot *forget* to write it.

There is also `validValue (m)`, which returns the contents with no default. It is
only correct where you have already established validity; `fromMaybe` is the one
to reach for by default.
