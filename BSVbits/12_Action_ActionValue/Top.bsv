// ============================================================================
// 12 -- Action, ActionValue, and value methods
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// Up to now your modules have only had value methods -- pure combinational
// outputs. This is the other half: methods the OUTSIDE calls to change your
// module's state.
// ============================================================================

package Top;

interface Acc_IFC;
   // Add x to the running total, and count the call.
   method Action add (Bit #(8) x);

   // Return the current total AND reset it to 0, in one operation.
   // The value returned is the total BEFORE the reset.
   method ActionValue #(Bit #(8)) takeAndClear ();

   // The running total. No side effect.
   method Bit #(8) total ();

   // How many times `add` has been called. Never reset.
   method Bit #(8) count ();
endinterface

(* synthesize *)
module mkTop (Acc_IFC);

   // TODO: your code here.
   //
   // Two registers, then the four methods. Note the three method kinds:
   //
   //   method Action f (...);              -- changes state, returns nothing
   //   method ActionValue #(t) g (...);    -- changes state AND returns a t
   //   method t h (...);                   -- returns a t, changes nothing

   method Action add (Bit #(8) x);
      noAction;
   endmethod

   method ActionValue #(Bit #(8)) takeAndClear ();
      return 0;
   endmethod

   method Bit #(8) total ();
      return 0;
   endmethod

   method Bit #(8) count ();
      return 0;
   endmethod

endmodule

endpackage
