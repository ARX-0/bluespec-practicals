// ============================================================================
// 15 -- case
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Sel_IFC;
   // A four-input multiplexer.
   method Bit #(8) mux4 (Bit #(2) sel, Bit #(8) a, Bit #(8) b,
                                       Bit #(8) c, Bit #(8) d);

   // 2 bits in, one-hot 4 bits out: 0->0001, 1->0010, 2->0100, 3->1000.
   method Bit #(4) oneHot (Bit #(2) sel);
endinterface

(* synthesize *)
module mkTop (Sel_IFC);

   method Bit #(8) mux4 (Bit #(2) sel, Bit #(8) a, Bit #(8) b,
                                       Bit #(8) c, Bit #(8) d);
      return 0;                 // TODO
   endmethod

   method Bit #(4) oneHot (Bit #(2) sel);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
