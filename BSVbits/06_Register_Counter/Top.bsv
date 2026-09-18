// ============================================================================
// 06 -- Registers and Rules
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// This is the problem where BSV stops being "Verilog with different syntax".
// Read the README properly before you start.
// ============================================================================

package Top;

interface Counter_IFC;
   // Increments by 1 every single cycle, starting from 0. Wraps at 255.
   method Bit #(8) count;

   // The value `count` had one cycle ago. (At the very first cycle: 0.)
   method Bit #(8) delayed;

   // Increments by 1 only on cycles where `count` is EVEN. Starts at 0.
   method Bit #(8) evens;
endinterface

(* synthesize *)
module mkTop (Counter_IFC);

   // TODO: declare your registers here, e.g.
   //
   //    Reg #(Bit #(8)) count <- mkReg (0);
   //
   // then write the rules that update them, then return them from the methods.
   //
   // The three `return 0` placeholders below let the file compile so you can
   // run the checker and watch it fail before you have written anything.

   method Bit #(8) count;
      return 0;
   endmethod

   method Bit #(8) delayed;
      return 0;
   endmethod

   method Bit #(8) evens;
      return 0;
   endmethod

endmodule

endpackage
