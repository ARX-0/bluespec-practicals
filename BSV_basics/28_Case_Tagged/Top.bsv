// ============================================================================
// 28 -- case ... matches
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Tagged_IFC;
   // Twice the value if there is one, otherwise 0.
   method Bit #(8) doubleOrZero (Maybe #(Bit #(8)) m);

   // A Maybe holding one more than m held; still invalid if m was.
   method Maybe #(Bit #(8)) incr (Maybe #(Bit #(8)) m);
endinterface

(* synthesize *)
module mkTop (Tagged_IFC);

   method Bit #(8) doubleOrZero (Maybe #(Bit #(8)) m);
      return 0;                 // TODO
   endmethod

   method Maybe #(Bit #(8)) incr (Maybe #(Bit #(8)) m);
      return tagged Invalid;    // TODO
   endmethod

endmodule

endpackage
