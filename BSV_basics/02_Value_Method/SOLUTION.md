# Solution — 02

```bsv
method Bit #(8) same (Bit #(8) a);
   return a;
endmethod

method Bit #(8) second (Bit #(8) a, Bit #(8) b);
   return b;
endmethod
```

Both are pure wire. `bsc` emits no logic for either — the argument port is
connected straight to the result port. An unused argument (`a` in `second`) is
fine; it just leaves an unread input port on the module.
