// ============================================================================
// 02 -- Muxes and Types
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Types_IFC;
   // A 4:1 mux over 8-bit data. sel picks d0/d1/d2/d3.
   method Bit #(8) mux4 (Bit #(2) sel,
                         Bit #(8) d0, Bit #(8) d1, Bit #(8) d2, Bit #(8) d3);

   // Swap the high and low nibbles: 0xAB -> 0xBA
   method Bit #(8) swapNibbles (Bit #(8) x);

   // UNSIGNED  a > b
   method Bool ugt (Bit #(8) a, Bit #(8) b);

   // SIGNED (two's complement)  a > b   -- same bits, different meaning
   method Bool sgt (Bit #(8) a, Bit #(8) b);
endinterface

(* synthesize *)
module mkTop (Types_IFC);

   // TODO: your code here.

   method Bit #(8) mux4 (Bit #(2) sel,
                         Bit #(8) d0, Bit #(8) d1, Bit #(8) d2, Bit #(8) d3);
      return 0;
   endmethod

   method Bit #(8) swapNibbles (Bit #(8) x);
      return 0;
   endmethod

   method Bool ugt (Bit #(8) a, Bit #(8) b);
      return False;
   endmethod

   method Bool sgt (Bit #(8) a, Bit #(8) b);
      return False;
   endmethod

endmodule

endpackage
