// ============================================================================
// 06 -- UInt and Int
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Num_IFC;
   // Unsigned arithmetic.
   method UInt #(8) sumU (UInt #(8) a, UInt #(8) b);

   // UNSIGNED comparison.
   method Bool lessU (UInt #(8) a, UInt #(8) b);

   // SIGNED comparison -- same eight bits, different answer.
   method Bool lessS (Int #(8) a, Int #(8) b);
endinterface

(* synthesize *)
module mkTop (Num_IFC);

   method UInt #(8) sumU (UInt #(8) a, UInt #(8) b);
      return 0;                 // TODO
   endmethod

   method Bool lessU (UInt #(8) a, UInt #(8) b);
      return False;             // TODO
   endmethod

   method Bool lessS (Int #(8) a, Int #(8) b);
      return False;             // TODO
   endmethod

endmodule

endpackage
