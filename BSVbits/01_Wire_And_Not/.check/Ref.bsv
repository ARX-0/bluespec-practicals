// Golden reference for problem 01.
//
// Written as literal truth tables on purpose. This is the *specification*,
// not the solution -- the point of the problem is to express these as gate
// expressions, and copying the tables back would miss it entirely.

package Ref;
import Top :: *;

(* synthesize *)
module mkRef (Gates_IFC);

   method Bit #(1) nand2 (Bit #(1) a, Bit #(1) b);
      return ((a == 1) && (b == 1)) ? 0 : 1;
   endmethod

   method Bit #(1) nor2 (Bit #(1) a, Bit #(1) b);
      return ((a == 0) && (b == 0)) ? 1 : 0;
   endmethod

   method Bit #(1) xnor2 (Bit #(1) a, Bit #(1) b);
      return (a == b) ? 1 : 0;
   endmethod

   method Bit #(1) mux2 (Bit #(1) sel, Bit #(1) a, Bit #(1) b);
      return (sel == 0) ? a : b;
   endmethod

endmodule

endpackage
