// ============================================================================
// 38 -- Action Methods
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Store_IFC;
   // Store x. This CHANGES the module, so it is an Action.
   method Action set (Bit #(8) x);

   // Read what is stored. No Action -- it changes nothing.
   method Bit #(8) get ();

   // Add x to what is stored.
   method Action add (Bit #(8) x);
endinterface

(* synthesize *)
module mkTop (Store_IFC);

   Reg #(Bit #(8)) r <- mkReg (0);

   method Action set (Bit #(8) x);
      noAction;                 // TODO
   endmethod

   method Bit #(8) get ();
      return r;
   endmethod

   method Action add (Bit #(8) x);
      noAction;                 // TODO
   endmethod

endmodule

endpackage
