// ============================================================================
// 39 -- ActionValue Methods
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Ticket_IFC;
   // Hand out the next ticket number AND move on to the following one.
   // Both things, in one call.
   method ActionValue #(Bit #(8)) take ();

   // What the next ticket number will be. Changes nothing.
   method Bit #(8) peek ();
endinterface

(* synthesize *)
module mkTop (Ticket_IFC);

   Reg #(Bit #(8)) next <- mkReg (0);

   method ActionValue #(Bit #(8)) take ();
      return 0;                 // TODO -- also advance `next`
   endmethod

   method Bit #(8) peek ();
      return next;
   endmethod

endmodule

endpackage
