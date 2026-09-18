// ============================================================================
// 14 -- if / else inside a Method
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Cond_IFC;
   // 0 if x is below 10, 1 if 10..99, 2 if 100 or more.
   method Bit #(2) band (Bit #(8) x);

   // -1, 0 or +1 according to the sign of x.
   method Int #(8) signOf (Int #(8) x);
endinterface

(* synthesize *)
module mkTop (Cond_IFC);

   method Bit #(2) band (Bit #(8) x);
      return 0;                 // TODO
   endmethod

   method Int #(8) signOf (Int #(8) x);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
