// Golden reference for problem 06 -- specification, not solution.
// Uses one combined rule and a different decomposition from the natural answer.
package Ref;
import Top :: *;

(* synthesize *)
module mkRef (Counter_IFC);

   Reg #(Bit #(8)) c    <- mkReg (0);
   Reg #(Bit #(8)) prev <- mkReg (0);
   Reg #(Bit #(8)) ev   <- mkReg (0);

   (* fire_when_enabled, no_implicit_conditions *)
   rule everything;
      c    <= c + 1;
      prev <= c;
      ev   <= (c[0] == 0) ? ev + 1 : ev;
   endrule

   method Bit #(8) count   = c;
   method Bit #(8) delayed = prev;
   method Bit #(8) evens   = ev;

endmodule

endpackage
