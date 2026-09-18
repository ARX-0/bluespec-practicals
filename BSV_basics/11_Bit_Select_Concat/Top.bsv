// ============================================================================
// 11 -- Bit Selection and Concatenation
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Slice_IFC;
   // The top nibble, by explicit index.
   method Bit #(4) high4 (Bit #(8) a);

   // One single bit -- bit 3.
   method Bit #(1) bit3 (Bit #(8) a);

   // Glue two nibbles into a byte, hi on top.
   method Bit #(8) joinNibbles (Bit #(4) hi, Bit #(4) lo);

   // Swap the two halves of a byte.
   method Bit #(8) swapHalves (Bit #(8) a);
endinterface

(* synthesize *)
module mkTop (Slice_IFC);

   method Bit #(4) high4 (Bit #(8) a);
      return 0;                 // TODO
   endmethod

   method Bit #(1) bit3 (Bit #(8) a);
      return 0;                 // TODO
   endmethod

   method Bit #(8) joinNibbles (Bit #(4) hi, Bit #(4) lo);
      return 0;                 // TODO
   endmethod

   method Bit #(8) swapHalves (Bit #(8) a);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
