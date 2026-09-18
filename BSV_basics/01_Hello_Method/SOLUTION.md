# Solution — 01

```bsv
method Bit #(8) answer ();
   return 8'hA5;
endmethod
```

`8'hA5` is a *sized* literal: 8 bits wide, hex `A5`. The width is part of the
type, so `bsc` checks it against the method's declared `Bit#(8)` return type.
A bare `165` would also work here — BSV would infer the width from context —
but writing the width is the habit worth having.
