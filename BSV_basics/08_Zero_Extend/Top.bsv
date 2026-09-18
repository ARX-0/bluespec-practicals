// ============================================================================
// 08 -- zeroExtend
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Widen_IFC;
   // 4 bits in, 8 bits out, top four bits zero.
   method Bit #(8) widen8 (Bit #(4) a);

   // 8 bits in, 16 bits out.
   method Bit #(16) widen16 (Bit #(8) a);

   // Add a 4-bit value to an 8-bit one. The widths must match FIRST.
   method Bit #(8) addNibble (Bit #(8) a, Bit #(4) n);
endinterface

(* synthesize *)
module mkTop (Widen_IFC);

   method Bit #(8) widen8 (Bit #(4) a);
      return 0;                 // TODO
   endmethod

   method Bit #(16) widen16 (Bit #(8) a);
      return 0;                 // TODO
   endmethod

   method Bit #(8) addNibble (Bit #(8) a, Bit #(4) n);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
