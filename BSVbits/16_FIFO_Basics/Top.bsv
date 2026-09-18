// ============================================================================
// 16 -- The library FIFOs
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// In problem 13 you built a buffer by hand. From here on you use the library
// one -- and the interesting part is that there are several, differing only
// in what may happen in the SAME cycle.
// ============================================================================

package Top;

import FIFOF :: *;

interface Stage_IFC;
   // Accept an item. Guarded: only when there is room.
   method Action enq (Bit #(8) x);

   // Produce a transformed item, in order. Guarded: only when one is ready.
   // The transform is  x + 1.
   method ActionValue #(Bit #(8)) deq ();

   method Bool notFull ();     // can enq be called this cycle?
   method Bool notEmpty ();    // can deq be called this cycle?
endinterface

(* synthesize *)
module mkTop (Stage_IFC);

   // TODO: your code here.
   //
   // Build it as TWO FIFOs with a rule moving data between them:
   //
   //    FIFOF #(Bit #(8)) inF  <- mkFIFOF;
   //    FIFOF #(Bit #(8)) outF <- mkFIFOF;
   //
   //    rule move;
   //       ... take from inF, enq the transformed value into outF ...
   //    endrule
   //
   // Do not write any flow control. The FIFOs' guards give it to you.

   method Action enq (Bit #(8) x);
      noAction;
   endmethod

   method ActionValue #(Bit #(8)) deq ();
      return 0;
   endmethod

   method Bool notFull ()  = False;
   method Bool notEmpty () = False;

endmodule

endpackage
