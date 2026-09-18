# Solution — 26

```bsv
method Maybe #(Bit #(8)) wrap (Bit #(8) x);
   return tagged Valid x;
endmethod

method Maybe #(Bit #(8)) nothing ();
   return tagged Invalid;
endmethod

method Maybe #(Bit #(8)) maybeVal (Bool ok, Bit #(8) x);
   return ok ? tagged Valid x : tagged Invalid;
endmethod
```

`maybeVal` is an ordinary ternary (problem 13) — both arms are `Maybe#(Bit#(8))`,
so the types line up.

The generated hardware is nine wires: your eight, plus the tag. `tagged Invalid`
leaves the eight data wires unconstrained, which is exactly right — nobody is
allowed to look at them, and problem 27 is about why they cannot.
