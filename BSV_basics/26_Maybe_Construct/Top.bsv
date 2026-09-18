// ============================================================================
// 26 -- Maybe
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Maybe_IFC;
   // Always a value.
   method Maybe #(Bit #(8)) wrap (Bit #(8) x);

   // Never a value.
   method Maybe #(Bit #(8)) nothing ();

   // A value only when ok is True.
   method Maybe #(Bit #(8)) maybeVal (Bool ok, Bit #(8) x);
endinterface

(* synthesize *)
module mkTop (Maybe_IFC);

   method Maybe #(Bit #(8)) wrap (Bit #(8) x);
      return tagged Invalid;    // TODO
   endmethod

   method Maybe #(Bit #(8)) nothing ();
      return tagged Invalid;    // TODO -- already right
   endmethod

   method Maybe #(Bit #(8)) maybeVal (Bool ok, Bit #(8) x);
      return tagged Invalid;    // TODO
   endmethod

endmodule

endpackage
