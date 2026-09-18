// ============================================================================
// 24 -- A pipeline around a memory latency
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// A BRAM answers one cycle late. That means a load cannot be a single
// atomic step -- it has to become "issue the request" and, later, "use the
// answer". Splitting a stage around a latency is the load-use problem, and
// it is the shape of every CPU memory stage.
// ============================================================================

package Top;

import BRAM         :: *;
import DefaultValue :: *;
import GetPut       :: *;
import ClientServer :: *;
import FIFOF        :: *;

interface MemPipe_IFC;
   // Preload the memory.
   method Action writeMem (Bit #(8) a, Bit #(8) d);

   // Issue a load of address a. Guarded: only when the pipeline can take it.
   method Action load (Bit #(8) a);

   // Collect the next finished load, IN ORDER. The value is mem[a] + 1.
   // Guarded: only when a result is ready.
   method ActionValue #(Bit #(8)) loadResult ();
endinterface

(* synthesize *)
module mkTop (MemPipe_IFC);

   // TODO: your code here.
   //
   //    BRAM_Configure cfg = defaultValue;
   //    cfg.memorySize = 256;
   //    BRAM1Port #(Bit #(8), Bit #(8)) bram <- mkBRAM1Server (cfg);
   //    FIFOF #(Bit #(8)) outQ <- mkFIFOF;
   //
   // `load` issues a read request to the BRAM.
   //
   // A RULE collects the BRAM's response, adds 1, and enqueues into outQ.
   // That rule is the second half of the load -- it runs a cycle later,
   // on its own, whenever an answer shows up.
   //
   // `loadResult` hands items out of outQ.
   //
   // The testbench will issue a load AND collect a result in the same
   // cycle, repeatedly. That works because the two halves are separate:
   // several loads can be in flight at once.

   method Action writeMem (Bit #(8) a, Bit #(8) d);
      noAction;
   endmethod

   method Action load (Bit #(8) a);
      noAction;
   endmethod

   method ActionValue #(Bit #(8)) loadResult ();
      return 0;
   endmethod

endmodule

endpackage
