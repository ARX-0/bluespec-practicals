// ============================================================================
// 27 -- Asking a Maybe What It Holds
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Query_IFC;
   // Does m hold a value?
   method Bool valid (Maybe #(Bit #(8)) m);

   // The value if there is one, otherwise 0.
   method Bit #(8) orZero (Maybe #(Bit #(8)) m);

   // The value if there is one, otherwise d.
   method Bit #(8) orElse (Maybe #(Bit #(8)) m, Bit #(8) d);
endinterface

(* synthesize *)
module mkTop (Query_IFC);

   method Bool valid (Maybe #(Bit #(8)) m);
      return False;             // TODO
   endmethod

   method Bit #(8) orZero (Maybe #(Bit #(8)) m);
      return 0;                 // TODO
   endmethod

   method Bit #(8) orElse (Maybe #(Bit #(8)) m, Bit #(8) d);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
