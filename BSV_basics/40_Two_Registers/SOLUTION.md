# Solution — 40

```bsv
   Reg #(Bit #(8)) ra <- mkReg (8'h11);
   Reg #(Bit #(8)) rb <- mkReg (8'h22);

   rule swap;
      ra <= rb;
      rb <= ra;
   endrule

   method Bit #(8) getA ();
      return ra;
   endmethod

   method Bit #(8) getB ();
      return rb;
   endmethod
```

Two assignments, no temporary. Both right-hand sides are evaluated against the
state at the start of the cycle, so the two new values are `(old rb, old ra)`.

In the generated Verilog this is two flip-flops whose `D` inputs are crossed. No
logic, no mux, no ordering — which is the point: a rule is not a sequence of
statements, it is a description of one transition.

Each register is written **once** in the rule. Writing `ra` twice would be an
error; if you find yourself wanting to, what you actually want is an `if`
choosing between the two values (problem 36).
