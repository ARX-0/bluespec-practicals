# Solution — 16

```bsv
method Bit #(8) lookup (Bit #(3) sel);
   return case (sel)
             3'd1: 8'hA1;
             3'd2: 8'hB2;
             3'd4: 8'hC4;
             default: 8'h00;
          endcase;
endmethod

method Bit #(3) firstSet (Bit #(4) n);
   return case (True)
             (n[0] == 1): 0;
             (n[1] == 1): 1;
             (n[2] == 1): 2;
             (n[3] == 1): 3;
             default:     4;
          endcase;
endmethod
```

`lookup` covers three of the eight values of a `Bit#(3)`, so `default` is
carrying real meaning — "the other five".

`firstSet` is a priority encoder. `case (True)` tests each arm in order and takes
the first that holds, so bit 0 wins over bit 1 without any extra `&& !n[0]`
conditions. An `if`/`else if` chain (problem 14) would be the same hardware; pick
whichever reads better.
