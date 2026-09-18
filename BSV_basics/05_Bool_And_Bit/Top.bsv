// ============================================================================
// 05 -- Bool is not Bit#(1)
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Bool_IFC;
   // Comparison produces a Bool, never a Bit#(1).
   method Bool isEqual (Bit #(8) a, Bit #(8) b);

   // Logical AND of two Bools.
   method Bool bothTrue (Bool p, Bool q);

   // Logical NOT.
   method Bool notP (Bool p);
endinterface

(* synthesize *)
module mkTop (Bool_IFC);

   method Bool isEqual (Bit #(8) a, Bit #(8) b);
      return False;             // TODO
   endmethod

   method Bool bothTrue (Bool p, Bool q);
      return False;             // TODO
   endmethod

   method Bool notP (Bool p);
      return False;             // TODO
   endmethod

endmodule

endpackage
