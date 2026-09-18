// ============================================================================
// 02 -- Value Methods with Arguments
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Wire_IFC;
   // Straight through: out = a.
   method Bit #(8) same (Bit #(8) a);

   // Two arguments in, the SECOND one out.
   method Bit #(8) second (Bit #(8) a, Bit #(8) b);
endinterface

(* synthesize *)
module mkTop (Wire_IFC);

   method Bit #(8) same (Bit #(8) a);
      return 0;                 // TODO
   endmethod

   method Bit #(8) second (Bit #(8) a, Bit #(8) b);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
