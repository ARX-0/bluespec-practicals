// ============================================================================
// 10 -- truncate
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Trunc_IFC;
   // Keep the LOW four bits of a.
   method Bit #(4) low4 (Bit #(8) a);

   // Keep the low byte.
   method Bit #(8) low8 (Bit #(16) a);

   // Keep the HIGH four bits of a.
   method Bit #(4) high4 (Bit #(8) a);
endinterface

(* synthesize *)
module mkTop (Trunc_IFC);

   method Bit #(4) low4 (Bit #(8) a);
      return 0;                 // TODO
   endmethod

   method Bit #(8) low8 (Bit #(16) a);
      return 0;                 // TODO
   endmethod

   method Bit #(4) high4 (Bit #(8) a);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
