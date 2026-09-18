// Golden reference for problem 10 -- specification, not solution.
// One rule, ordinary registers, the whole thing serialised by hand. This is
// the "just write it as one rule" answer; it is correct and it is exactly
// what CRegs let you stop doing.
package Ref;
import Top :: *;

(* synthesize *)
module mkRef (Drain_IFC);

   Reg #(Bit #(8)) c <- mkReg (0);
   Reg #(Bit #(8)) t <- mkReg (0);
   Reg #(Bit #(2)) p <- mkReg (0);

   (* fire_when_enabled, no_implicit_conditions *)
   rule everything;
      Bit #(8) incremented = c + 1;
      if (p == 3) begin
         t <= t + incremented;
         c <= 0;
      end
      else
         c <= incremented;
      p <= p + 1;
   endrule

   method Bit #(8) current = c;
   method Bit #(8) total   = t;

endmodule

endpackage
