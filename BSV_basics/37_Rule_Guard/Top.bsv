// ============================================================================
// 37 -- A Rule Guard
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// Compare this with problem 36. The counter behaves differently, and the only
// change is WHERE the condition goes.
// ============================================================================

package Top;

interface Stop_IFC;
   // Counts 0,1,2,...,10 and then stays at 10 forever.
   method Bit #(8) count ();
endinterface

(* synthesize *)
module mkTop (Stop_IFC);

   Reg #(Bit #(8)) r <- mkReg (0);

   // TODO: a rule that increments r -- but only while r is below 10.
   //       Put the condition ON THE RULE, not inside it.

   method Bit #(8) count ();
      return r;
   endmethod

endmodule

endpackage
