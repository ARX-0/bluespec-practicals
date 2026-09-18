# Solution — 15

```bsv
method Bit #(8) mux4 (Bit #(2) sel, Bit #(8) a, Bit #(8) b,
                                    Bit #(8) c, Bit #(8) d);
   case (sel)
      2'b00: return a;
      2'b01: return b;
      2'b10: return c;
      2'b11: return d;
   endcase
endmethod

method Bit #(4) oneHot (Bit #(2) sel);
   return case (sel)
             2'b00: 4'b0001;
             2'b01: 4'b0010;
             2'b10: 4'b0100;
             2'b11: 4'b1000;
          endcase;
endmethod
```

The expression form composes: a `case` can sit inside a larger expression, be
passed as an argument, or be the right-hand side of a `let`. The statement form
reads better when the arms are long.

Neither has a `default`, and that is deliberate — all four values of a `Bit#(2)`
are listed. Problem 20 will make this matter, where an enum grows and an
exhaustive `case` turns into an error pointing exactly at the code that needs
updating.
