# Solution — 11

```bsv
method Bit #(4) high4 (Bit #(8) a);   return a [7:4];  endmethod
method Bit #(1) bit3 (Bit #(8) a);    return a [3];    endmethod

method Bit #(8) joinNibbles (Bit #(4) hi, Bit #(4) lo);
   return {hi, lo};
endmethod

method Bit #(8) swapHalves (Bit #(8) a);
   return {a [3:0], a [7:4]};
endmethod
```

Concatenation is free — it is only a naming of wires, like `pack`.

`swapHalves` is the one worth noticing: the widths of the two pieces add up to
the declared return width, and `bsc` checks that sum. Get a slice wrong by one
bit and you get an error about the total, at this line, rather than a value that
is quietly off by a factor of two.
