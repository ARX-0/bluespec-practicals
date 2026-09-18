# Solution — 35

```bsv
   Reg #(Bit #(8)) ra <- mkReg (7);
   Reg #(Bit #(8)) rb <- mkReg (200);
   Reg #(Bool)     rf <- mkReg (True);

   method Bit #(8) a ();     return ra;  endmethod
   method Bit #(8) b ();     return rb;  endmethod
   method Bool flag ();      return rf;  endmethod
```

The registers are named `ra`/`rb`/`rf` because `a`, `b` and `flag` are already
taken by the methods — a register and a method cannot share a name in the same
module.

`mkReg (True)` needs no conversion: the register's type is `Reg#(Bool)`, so its
reset value is a `Bool`. This is the same type-directed behaviour as `unpack` in
problem 07 — `Bool` derives `Bits`, so it can be stored, and its `pack`ed width
(1) is the register's width.
