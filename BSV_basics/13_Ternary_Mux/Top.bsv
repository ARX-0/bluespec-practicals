// ============================================================================
// 13 -- The Ternary Operator
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Mux_IFC;
   // sel == False picks a, sel == True picks b.
   method Bit #(8) mux2 (Bool sel, Bit #(8) a, Bit #(8) b);

   // Same selection, but sel arrives as one raw bit: 0 picks a, 1 picks b.
   method Bit #(8) mux2b (Bit #(1) sel, Bit #(8) a, Bit #(8) b);

   // The larger of the two (unsigned).
   method Bit #(8) maxOf (Bit #(8) a, Bit #(8) b);
endinterface

(* synthesize *)
module mkTop (Mux_IFC);

   method Bit #(8) mux2 (Bool sel, Bit #(8) a, Bit #(8) b);
      return 0;                 // TODO
   endmethod

   method Bit #(8) mux2b (Bit #(1) sel, Bit #(8) a, Bit #(8) b);
      return 0;                 // TODO
   endmethod

   method Bit #(8) maxOf (Bit #(8) a, Bit #(8) b);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
