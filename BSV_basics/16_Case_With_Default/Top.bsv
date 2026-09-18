// ============================================================================
// 16 -- default, and When You Need It
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Dflt_IFC;
   // Three named codes; everything else is 0.
   //    3'd1 -> 8'hA1     3'd2 -> 8'hB2     3'd4 -> 8'hC4
   //    any other value of sel -> 8'h00
   method Bit #(8) lookup (Bit #(3) sel);

   // Number of the LOWEST set bit of a nibble (0..3), or 4 if none are set.
   method Bit #(3) firstSet (Bit #(4) n);
endinterface

(* synthesize *)
module mkTop (Dflt_IFC);

method Bit #(8) lookup (Bit #(3) sel);
      return 0;                 // TODO
endmethod

method Bit #(3) firstSet (Bit #(4) n);
      return 0;                 // TODO
endmethod

endmodule

endpackage
