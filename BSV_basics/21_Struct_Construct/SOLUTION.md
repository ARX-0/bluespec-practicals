# Solution — 21

```bsv
method Point make (Bit #(8) a, Bit #(8) b);
   return Point { x: a, y: b };
endmethod

method Point origin ();
   return Point { x: 0, y: 0 };
endmethod

method Point diagonal (Bit #(8) v);
   return Point { x: v, y: v };
endmethod
```

`Point { ... }` is not a constructor call in any runtime sense — it is sixteen
wires being labelled, and it costs nothing.

Every field must be given. Omitting one is an error naming the missing field,
which is precisely what you want when the struct grows later.
