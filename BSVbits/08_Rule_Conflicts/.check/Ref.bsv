// Golden reference for problem 08 -- specification, not solution.
// One rule, no conflict possible, so it says nothing about how to resolve one.
package Ref;
import Top :: *;

(* synthesize *)
module mkRef (Conflict_IFC);

   Reg #(Bit #(8)) c <- mkReg (0);
   Reg #(Bit #(8)) r <- mkReg (0);

   (* fire_when_enabled, no_implicit_conditions *)
   rule everything;
      if (c == 9) begin
         c <= 0;
         r <= r + 1;
      end
      else
         c <= c + 1;
   endrule

   method Bit #(8) count  = c;
   method Bit #(8) resets = r;

endmodule

endpackage
