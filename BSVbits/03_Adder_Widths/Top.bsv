// ============================================================================
// 03 -- Adders and Bit Widths
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Adder_IFC;
   // 8-bit add with carry-in, producing the FULL 9-bit result.
   // Nothing is lost: bit 8 is the carry-out.
   method Bit #(9) add8 (Bit #(8) a, Bit #(8) b, Bit #(1) cin);

   // Widen 8 -> 16, filling the new high bits with zero.
   method Bit #(16) zext (Bit #(8) x);

   // Widen 8 -> 16, replicating the sign bit (two's complement).
   method Bit #(16) sext (Bit #(8) x);

   // Narrow 16 -> 8, keeping the low byte.
   method Bit #(8) trunc (Bit #(16) x);
endinterface

(* synthesize *)
module mkTop (Adder_IFC);

   // TODO: your code here.

   method Bit #(9) add8 (Bit #(8) a, Bit #(8) b, Bit #(1) cin);
      return 0;
   endmethod

   method Bit #(16) zext (Bit #(8) x);
      return 0;
   endmethod

   method Bit #(16) sext (Bit #(8) x);
      return 0;
   endmethod

   method Bit #(8) trunc (Bit #(16) x);
      return 0;
   endmethod

endmodule

endpackage
