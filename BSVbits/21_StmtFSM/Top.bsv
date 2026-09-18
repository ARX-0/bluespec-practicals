// ============================================================================
// 21 -- StmtFSM: sequential code that compiles to a state machine
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// Rules are unordered by design. Sometimes you genuinely want "do this,
// then that, then loop until done" -- and writing that as rules plus a
// state enum is tedious. StmtFSM writes the state machine for you.
// ============================================================================

package Top;

import StmtFSM :: *;
import FIFOF   :: *;

interface Sum_IFC;
   // Begin summing 0 + 1 + ... + (n-1). Guarded: only when idle.
   method Action start (Bit #(8) n);

   // Is a computation in progress?
   method Bool busy ();

   // The finished sum. Guarded: only when a result is ready.
   method ActionValue #(Bit #(16)) result ();
endinterface

(* synthesize *)
module mkTop (Sum_IFC);

   // TODO: your code here.
   //
   // Suggested state:
   //    Reg #(Bit #(8))  n_r <- mkReg (0);
   //    Reg #(Bit #(8))  i   <- mkReg (0);
   //    Reg #(Bit #(16)) acc <- mkReg (0);
   //    FIFOF #(Bit #(16)) outQ <- mkFIFOF;
   //
   // Then describe the algorithm as a Stmt and hand it to mkFSM:
   //
   //    Stmt prog = seq
   //                   action ... endaction     // one clock cycle
   //                   while (...) seq
   //                      action ... endaction  // one cycle per iteration
   //                   endseq
   //                   ...
   //                endseq;
   //
   //    FSM fsm <- mkFSM (prog);
   //
   // `start` sets n_r and calls fsm.start; `busy` is !fsm.done.

   method Action start (Bit #(8) n);
      noAction;
   endmethod

   method Bool busy () = False;

   method ActionValue #(Bit #(16)) result ();
      return 0;
   endmethod

endmodule

endpackage
