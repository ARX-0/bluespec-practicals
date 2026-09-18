// ============================================================================
// 33 -- Your First Register
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// Chapter G. Everything up to here was combinational -- pure functions of the
// arguments. From now on the module remembers things.
// ============================================================================

package Top;

interface Store_IFC;
   // What the register currently holds.
   method Bit #(8) get ();
endinterface

(* synthesize *)
module mkTop (Store_IFC);

   // TODO: instantiate a register here, holding Bit#(8), starting at 42.

   method Bit #(8) get ();
      return 0;                 // TODO -- return what the register holds
   endmethod

endmodule

endpackage
