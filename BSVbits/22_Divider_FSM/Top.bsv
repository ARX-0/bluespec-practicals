// ============================================================================
// 22 -- The same machine, by hand
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// Problem 21 let StmtFSM write the state machine. Here you write one
// yourself, with an explicit state register -- because when a design needs
// to react to things arriving from outside, a rigid `seq` is the wrong tool
// and you go back to guarded rules.
// ============================================================================

package Top;

import FIFOF :: *;

typedef struct {
   Bit #(16) quo;
   Bit #(16) rem;
} DivResult deriving (Bits, Eq, FShow);

interface Div_IFC;
   // Start num / den. Guarded: only when idle. den is never 0.
   method Action start (Bit #(16) num, Bit #(8) den);

   // The finished quotient and remainder. Guarded.
   method ActionValue #(DivResult) result ();
endinterface

(* synthesize *)
module mkTop (Div_IFC);

   // TODO: your code here.
   //
   // Restoring division, 16 iterations, one per cycle:
   //
   //    rem = 0; quo = num;
   //    repeat 16 times:
   //       shift the top bit of quo into the bottom of rem
   //       shift quo left by 1
   //       if (rem >= den) { rem -= den; set quo's bottom bit }
   //
   // After 16 iterations quo holds the quotient and rem the remainder.
   //
   // Suggested state:
   //    Reg #(Bit #(16))     quo   <- mkReg (0);
   //    Reg #(Bit #(16))     rem   <- mkReg (0);
   //    Reg #(Bit #(8))      den_r <- mkReg (0);
   //    Reg #(Bit #(5))      step  <- mkReg (16);   // 16 == idle
   //    FIFOF #(DivResult)   outQ  <- mkFIFOF;
   //
   // Same idle-marker trick as problem 20: `step == 16` means idle, so
   // `start`'s guard and the iteration rule's guard are mutually exclusive.

   method Action start (Bit #(16) num, Bit #(8) den);
      noAction;
   endmethod

   method ActionValue #(DivResult) result ();
      return DivResult { quo: 0, rem: 0 };
   endmethod

endmodule

endpackage
