// ============================================================================
// 34 -- A Rule
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Count_IFC;
   // The counter's current value.
   method Bit #(8) count ();
endinterface

(* synthesize *)
module mkTop (Count_IFC);

   Reg #(Bit #(8)) r <- mkReg (0);

   // TODO: a rule here that adds one to r every cycle.

   method Bit #(8) count ();
      return r;
   endmethod

endmodule

endpackage
