// Golden reference for problem 09 -- specification, not solution.
// Uses a packed Bit#(3) for the delay line instead of a Vector of registers,
// which is the alternative style the problem is steering you away from.
package Ref;
import Top :: *;

(* synthesize *)
module mkRef (Shift_IFC);

   Reg #(Bit #(8)) s <- mkReg (8'hFF);
   Reg #(Bit #(3)) d <- mkReg (0);

   (* fire_when_enabled, no_implicit_conditions *)
   rule step;
      Bit #(1) nb = s[7] ^ s[5] ^ s[4] ^ s[3];
      s <= { s[6:0], nb };
      d <= { d[1:0], s[0] };
   endrule

   method Bit #(8) lfsr     = s;
   method Bit #(1) delayed3 = d[2];

endmodule

endpackage
