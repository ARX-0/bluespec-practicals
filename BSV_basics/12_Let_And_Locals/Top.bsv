// ============================================================================
// 12 -- let, and Naming Intermediate Values
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Local_IFC;
   // (a + b) XOR (a - b), computed via two named intermediates.
   method Bit #(8) mix (Bit #(8) a, Bit #(8) b);

   // The average of a and b, with NO overflow: widen, add, halve, narrow.
   method Bit #(8) avg (Bit #(8) a, Bit #(8) b);
endinterface

(* synthesize *)
module mkTop (Local_IFC);

   method Bit #(8) mix (Bit #(8) a, Bit #(8) b);
      return 0;                 // TODO
   endmethod

method Bit #(8) avg (Bit #(8) a, Bit #(8) b);
      return 0;                 // TODO
endmethod

endmodule

endpackage
