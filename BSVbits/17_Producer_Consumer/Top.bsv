// ============================================================================
// 17 -- Producer / Consumer: backpressure you did not write
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// A producer that can run every cycle, a consumer that can only run every
// 4th cycle, and a FIFO between them. Count the lines of flow-control code
// you have to write. It is zero.
// ============================================================================

package Top;

import FIFOF :: *;

interface PC_IFC;
   // Hand out the consumer's results, in order.
   // Guarded: only when a result is available.
   method ActionValue #(Bit #(16)) result ();

   method Bool hasResult ();
endinterface

(* synthesize *)
module mkTop (PC_IFC);

   // TODO: your code here.
   //
   // Build this:
   //
   //   rule produce;             every cycle: enq the next value 0,1,2,3,...
   //                             into a FIFOF, and bump the counter
   //   rule tick;                every cycle: advance a 2-bit phase counter
   //   rule consume (phase==0);  every 4th cycle: take one value x from the
   //                             FIFO and enq x*x into an output FIFOF
   //
   // then `result` hands items out of the output FIFO.
   //
   // The producer generates 4x faster than the consumer drains. Write NO
   // flow control -- the FIFO's guards stall `produce` on their own. The
   // sequence out must be 0, 1, 4, 9, 16, 25, ... with nothing dropped.

   method ActionValue #(Bit #(16)) result ();
      return 0;
   endmethod

   method Bool hasResult () = False;

endmodule

endpackage
