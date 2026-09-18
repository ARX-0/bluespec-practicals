// ============================================================================
// 04 -- Literals and Widths
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Lit_IFC;
   method Bit #(8) hexLit  ();   // 0xF0
   method Bit #(8) decLit  ();   // 42
   method Bit #(8) binLit  ();   // 0000_1111
   method Bit #(8) allOnes ();   // every bit set
   method Bit #(8) zeros   ();   // every bit clear
endinterface

(* synthesize *)
module mkTop (Lit_IFC);

   method Bit #(8) hexLit ();
      return 0;                 // TODO
   endmethod

   method Bit #(8) decLit ();
      return 0;                 // TODO
   endmethod

   method Bit #(8) binLit ();
      return 0;                 // TODO
   endmethod

   method Bit #(8) allOnes ();
      return 0;                 // TODO
   endmethod

   method Bit #(8) zeros ();
      return 0;                 // TODO -- this one is already right
   endmethod

endmodule

endpackage
