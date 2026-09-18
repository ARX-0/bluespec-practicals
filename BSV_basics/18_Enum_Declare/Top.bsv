// ============================================================================
// 18 -- Declaring an Enum
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// Here you write a TYPE, not just a method body.
// ============================================================================

package Top;

// TODO: declare an enum type called Color with three values, in this order:
//
//       Red, Green, Blue
//
// It must derive Bits, Eq and FShow. See README.md for the shape.

interface Enum_IFC;
   // The bit encoding of each colour. Once Color exists, each of these is
   // pack (Red), pack (Green), pack (Blue).
   method Bit #(2) redBits   ();
   method Bit #(2) greenBits ();
   method Bit #(2) blueBits  ();
endinterface

(* synthesize *)
module mkTop (Enum_IFC);

   method Bit #(2) redBits ();
      return 0;                 // TODO -- pack (Red)
   endmethod

   method Bit #(2) greenBits ();
      return 0;                 // TODO
   endmethod

   method Bit #(2) blueBits ();
      return 0;                 // TODO
   endmethod

endmodule

endpackage
