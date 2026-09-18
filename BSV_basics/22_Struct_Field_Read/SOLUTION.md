# Solution — 22

```bsv
method Bit #(8) getX (Point p);   return p.x;        endmethod
method Bit #(8) getY (Point p);   return p.y;        endmethod
method Bit #(8) sumXY (Point p);  return p.x + p.y;  endmethod

method Point swapXY (Point p);
   return Point { x: p.y, y: p.x };
endmethod
```

`swapXY` is construction (problem 21) and field reading (this one) in the same
expression, and it is the whole vocabulary you need for structs: take fields out
by name, put a new value together by name.

The generated hardware for `swapXY` is a crossing of wires — the adder in
`sumXY` is the only gate in this entire file.
