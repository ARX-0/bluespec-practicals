// ============================================================================
// 19 -- An elastic pipeline
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// Three stages, each a rule with a FIFO in front of it. The point is not
// the arithmetic -- it is that the pipeline must accept a new item AND
// produce a finished one in the SAME cycle, indefinitely.
// ============================================================================

package Top;

import FIFOF :: *;

interface Pipe_IFC;
   method Action put (Bit #(8) x);              // guarded
   method ActionValue #(Bit #(16)) get ();      // guarded
   method Bool canPut ();
   method Bool canGet ();
endinterface

(* synthesize *)
module mkTop (Pipe_IFC);

   // TODO: your code here.
   //
   // Three stages, in order:
   //    stage 1:  y = x + 1          (Bit#(8)  -> Bit#(8))
   //    stage 2:  y = x * 3          (Bit#(8)  -> Bit#(16))
   //    stage 3:  y = x ^ 16'hAAAA   (Bit#(16) -> Bit#(16))
   //
   // So the overall function is  ((x + 1) * 3) ^ 0xAAAA.
   //
   // Use FOUR FIFOFs -- one at the input, one between each pair of stages,
   // one at the output -- and three rules. Each rule takes from the FIFO
   // before it and enqueues into the FIFO after it. Write no flow control.
   //
   // The testbench will call put and get in the SAME cycle, over and over.
   // If your pipeline cannot sustain that it will stall and the watchdog
   // will say so.

   method Action put (Bit #(8) x);
      noAction;
   endmethod

   method ActionValue #(Bit #(16)) get ();
      return 0;
   endmethod

   method Bool canPut () = False;
   method Bool canGet () = False;

endmodule

endpackage
