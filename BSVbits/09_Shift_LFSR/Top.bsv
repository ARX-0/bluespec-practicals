// ============================================================================
// 09 -- Shift Registers and an LFSR
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

import Vector :: *;

interface Shift_IFC;
   // An 8-bit LFSR, seeded to 0xFF, shifting LEFT once per cycle.
   //   newbit = s[7] ^ s[5] ^ s[4] ^ s[3]
   //   s      = { s[6:0], newbit }
   method Bit #(8) lfsr;

   // A 3-deep delay line fed with the LFSR's bit 0 (as sampled BEFORE the
   // shift, i.e. the current s[0] each cycle). This method returns the bit
   // that entered the line 3 cycles ago. Everything starts at 0.
   method Bit #(1) delayed3;
endinterface

(* synthesize *)
module mkTop (Shift_IFC);

   // TODO: your code here.
   //
   // For the delay line, try a Vector of registers rather than three
   // separately named ones:
   //
   //    Vector #(3, Reg #(Bit #(1))) dl <- replicateM (mkReg (0));
   //
   // `replicateM` instantiates the module n times -- note the `M`, and note
   // that it needs `<-`, because instantiating is an action.

   method Bit #(8) lfsr;
      return 0;
   endmethod

   method Bit #(1) delayed3;
      return 0;
   endmethod

endmodule

endpackage
