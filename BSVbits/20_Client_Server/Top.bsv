// ============================================================================
// 20 -- Client, Server, and a multi-cycle unit
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// A shift-and-add multiplier that takes 8 cycles per result, wrapped in the
// standard request/response interface. This is the shape of every memory,
// every bus slave, and every long-latency functional unit you will build.
// ============================================================================

package Top;

import FIFOF      :: *;
import GetPut     :: *;
import ClientServer :: *;

typedef struct {
   Bit #(8) a;
   Bit #(8) b;
} MulReq deriving (Bits, Eq, FShow);

interface Mul_IFC;
   // Server #(request_type, response_type) is just:
   //    interface Put #(request_type)  request;
   //    interface Get #(response_type) response;
   interface Server #(MulReq, Bit #(16)) srv;
endinterface

(* synthesize *)
module mkTop (Mul_IFC);

   // TODO: your code here.
   //
   // A shift-and-add multiplier. Suggested state:
   //
   //    Reg #(Bit #(16)) prod  <- mkReg (0);   // accumulating result
   //    Reg #(Bit #(16)) mcand <- mkReg (0);   // multiplicand, shifted left
   //    Reg #(Bit #(8))  mplr  <- mkReg (0);   // multiplier, shifted right
   //    Reg #(Bit #(4))  step  <- mkReg (8);   // 8 = idle, 0..7 = working
   //    FIFOF #(Bit #(16)) outQ <- mkFIFOF;
   //
   // Accept a request only when idle (step == 8). Then on each of 8 cycles:
   // if the low bit of mplr is 1, add mcand to prod; shift mcand left and
   // mplr right; count the step. After the 8th, enqueue prod.
   //
   // Expose it as:
   //    interface srv = toGPServer (inQ, outQ);      -- if you use an input FIFO
   // or build the Server interface by hand:
   //    interface Server srv;
   //       interface Put request;  ... endinterface
   //       interface Get response; ... endinterface
   //    endinterface

   interface Server srv;
      interface Put request;
         method Action put (MulReq r);
            noAction;
         endmethod
      endinterface
      interface Get response;
         method ActionValue #(Bit #(16)) get ();
            return 0;
         endmethod
      endinterface
   endinterface

endmodule

endpackage
