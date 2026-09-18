// ============================================================================
// 36 -- if inside a Rule
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Wrap_IFC;
   // Counts 0,1,2,...,9,0,1,... -- never reaches 10.
   method Bit #(8) count ();
endinterface

(* synthesize *)
module mkTop (Wrap_IFC);

   Reg #(Bit #(8)) r <- mkReg (0);

   // TODO: a rule that counts up, but goes back to 0 after 9.
   //       Fire EVERY cycle -- decide inside the rule what to write.

   method Bit #(8) count ();
      return r;
   endmethod

endmodule

endpackage
