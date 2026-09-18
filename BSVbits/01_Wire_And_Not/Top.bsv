// ============================================================================
// 01 -- Wires and Gates
//
// >>> THIS IS THE FILE YOU EDIT. <<<
//
// Fill in the four method bodies below. Do NOT change the interface: the
// checker instantiates your module through it, so renaming a method or
// changing a type will produce a type error instead of a result.
//
// Read README.md first. HINTS.md if you get stuck. SOLUTION.md only if dire.
// ============================================================================

package Top;

interface Gates_IFC;
   // Each of these is a *value method*: pure combinational logic, no state.
   // In the generated Verilog each one becomes a bundle of input wires and a
   // bundle of output wires -- nothing is clocked.

   method Bit #(1) nand2 (Bit #(1) a, Bit #(1) b);
   method Bit #(1) nor2  (Bit #(1) a, Bit #(1) b);
   method Bit #(1) xnor2 (Bit #(1) a, Bit #(1) b);

   // sel == 0 selects a, sel == 1 selects b.
   method Bit #(1) mux2  (Bit #(1) sel, Bit #(1) a, Bit #(1) b);
endinterface

(* synthesize *)
module mkTop (Gates_IFC);

   // TODO: your code here.
   //
   // A value method looks like this:
   //
   //    method Bit #(1) nand2 (Bit #(1) a, Bit #(1) b);
   //       return <your expression>;
   //    endmethod
   //
   // The `return 0` placeholders below make the file compile so you can run
   // the checker immediately and watch it fail. Replace them.

   method Bit #(1) nand2 (Bit #(1) a, Bit #(1) b);
      return 0;
   endmethod

   method Bit #(1) nor2 (Bit #(1) a, Bit #(1) b);
      return 0;
   endmethod

   method Bit #(1) xnor2 (Bit #(1) a, Bit #(1) b);
      return 0;
   endmethod

   method Bit #(1) mux2 (Bit #(1) sel, Bit #(1) a, Bit #(1) b);
      return 0;
   endmethod

endmodule

endpackage
