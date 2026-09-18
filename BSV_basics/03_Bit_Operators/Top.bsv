// ============================================================================
// 03 -- Bitwise Operators
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Ops_IFC;
   method Bit #(4) andOp (Bit #(4) a, Bit #(4) b);
   method Bit #(4) orOp  (Bit #(4) a, Bit #(4) b);
   method Bit #(4) xorOp (Bit #(4) a, Bit #(4) b);
   method Bit #(4) notOp (Bit #(4) a);
endinterface

(* synthesize *)
module mkTop (Ops_IFC);

   method Bit #(4) andOp (Bit #(4) a, Bit #(4) b);
      return 0;                 // TODO
   endmethod

   method Bit #(4) orOp (Bit #(4) a, Bit #(4) b);
      return 0;                 // TODO
   endmethod

   method Bit #(4) xorOp (Bit #(4) a, Bit #(4) b);
      return 0;                 // TODO
   endmethod

   method Bit #(4) notOp (Bit #(4) a);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
