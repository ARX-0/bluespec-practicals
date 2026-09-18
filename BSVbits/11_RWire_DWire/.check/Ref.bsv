// Golden reference for problem 11 -- specification, not solution.
// One rule, no wires at all: when everything is in a single rule you never
// need to communicate between rules, which is precisely why this version
// teaches you nothing about wires.
package Ref;
import Top :: *;

(* synthesize *)
module mkRef (Wire_IFC);

   Reg #(Bit #(8)) t <- mkReg (0);
   Reg #(Bit #(8)) h <- mkReg (0);
   Reg #(Bit #(8)) l <- mkReg (0);

   (* fire_when_enabled, no_implicit_conditions *)
   rule everything;
      t <= t + 1;
      if (t[1:0] == 0) begin
         h <= h + 1;
         l <= t;
      end
   endrule

   method Bit #(8) tick = t;
   method Bit #(8) hits = h;
   method Bit #(8) last = l;

endmodule

endpackage
