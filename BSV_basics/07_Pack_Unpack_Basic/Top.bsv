// ============================================================================
// 07 -- pack and unpack
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Conv_IFC;
   // Bool -> the one bit that represents it.
   method Bit #(1) toBit (Bool p);

   // ...and back.
   method Bool toBool (Bit #(1) b);

   // UInt#(8) -> its eight raw bits.
   method Bit #(8) uToBits (UInt #(8) u);

   // ...and back.
   method UInt #(8) bitsToU (Bit #(8) b);
endinterface

(* synthesize *)
module mkTop (Conv_IFC);

   method Bit #(1) toBit (Bool p);
      return 0;                 // TODO
   endmethod

   method Bool toBool (Bit #(1) b);
      return False;             // TODO
   endmethod

   method Bit #(8) uToBits (UInt #(8) u);
      return 0;                 // TODO
   endmethod

   method UInt #(8) bitsToU (Bit #(8) b);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
