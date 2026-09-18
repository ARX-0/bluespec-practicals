// ============================================================================
// 01 -- Hello, Method
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// Read README.md first. SOLUTION.md only if stuck.
// ============================================================================

package Top;

interface Const_IFC;
   method Bit #(8) answer ();
endinterface

(* synthesize *)
module mkTop (Const_IFC);

   method Bit #(8) answer ();
      return 0;                 // TODO: replace me
   endmethod

endmodule

endpackage
