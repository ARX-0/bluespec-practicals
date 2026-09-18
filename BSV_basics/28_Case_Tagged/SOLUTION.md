# Solution — 28

```bsv
method Bit #(8) doubleOrZero (Maybe #(Bit #(8)) m);
   case (m) matches
      tagged Valid .v : return v << 1;
      tagged Invalid  : return 0;
   endcase
endmethod

method Maybe #(Bit #(8)) incr (Maybe #(Bit #(8)) m);
   case (m) matches
      tagged Valid .v : return tagged Valid (v + 1);
      tagged Invalid  : return tagged Invalid;
   endcase
endmethod
```

Both arms are listed, so — as with the enum in problem 20 — no `default` is
needed and none should be added.

The parentheses in `tagged Valid (v + 1)` are required: `tagged Valid` takes one
expression, and without them the `+ 1` would try to apply to the whole tagged
value.

`incr` could also be written with `fromMaybe`, but not as cleanly: you would have
to reconstruct the tag separately, and the two halves could drift apart. Pattern
matching keeps the tag and the payload joined.
