// Golden reference for problem 07 -- specification, not solution.
// Deliberately written with unguarded rules and `if` inside the body: the
// behaviour is identical, and it is exactly the style the problem is asking
// you NOT to use. Read the README on why the guarded form is different.
package Ref;
import Top :: *;

(* synthesize *)
module mkRef (Sat_IFC);

   Reg #(Bit #(8)) u <- mkReg (0);
   Reg #(Bit #(8)) d <- mkReg (100);
   Reg #(Bit #(8)) s <- mkReg (0);

   (* fire_when_enabled, no_implicit_conditions *)
   rule saturate;
      if (u < 200) u <= u + 1;
      if (d > 0)   d <= d - 1;
      if (u < 50)  s <= s + 1;
   endrule

   method Bit #(8) up   = u;
   method Bit #(8) down = d;
   method Bit #(8) slow = s;

endmodule

endpackage
