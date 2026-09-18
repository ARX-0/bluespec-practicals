// ============================================================================
// 09 -- signExtend
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Sext_IFC;
   // Copy the top bit of a into all the new high bits.
   method Bit #(8) sext (Bit #(4) a);

   // The same four bits, widened the OTHER way, for contrast.
   method Bit #(8) zext (Bit #(4) a);

   // Signed types widen the signed way.
   method Int #(16) sextI (Int #(8) a);
endinterface

(* synthesize *)
module mkTop (Sext_IFC);

   method Bit #(8) sext (Bit #(4) a);
      return 0;                 // TODO
   endmethod

   method Bit #(8) zext (Bit #(4) a);
      return 0;                 // TODO
   endmethod

   method Int #(16) sextI (Int #(8) a);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
