// ============================================================================
// 40 -- Two Registers, One Rule
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Swap_IFC;
   method Bit #(8) getA ();
   method Bit #(8) getB ();
endinterface

(* synthesize *)
module mkTop (Swap_IFC);

   Reg #(Bit #(8)) ra <- mkReg (8'h11);
   Reg #(Bit #(8)) rb <- mkReg (8'h22);

   // TODO: one rule that exchanges the contents of ra and rb every cycle.
   //       No temporary register is needed. Think about what `ra` reads as
   //       while the rule is running.


   method Bit #(8) getA ();
      return ra;
   endmethod

   method Bit #(8) getB ();
      return rb;
   endmethod

endmodule

endpackage
