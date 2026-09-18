// Golden reference for problem 18 -- specification, not solution.
// One FIFO, the whole transform applied in a single method, no stages, no
// Get/Put plumbing at all. It defines WHAT the chain computes and says
// nothing about how to compose modules.
package Ref;
import Top    :: *;
import FIFOF  :: *;
import GetPut :: *;

(* synthesize *)
module mkRef (Chain_IFC);

   FIFOF #(Bit #(16)) q <- mkSizedFIFOF (8);

   interface Put request;
      method Action put (Bit #(8) x);
         Bit #(16) w = zeroExtend (x);
         q.enq ((w + 1) * 3);
      endmethod
   endinterface

   interface Get response;
      method ActionValue #(Bit #(16)) get ();
         q.deq;
         return q.first;
      endmethod
   endinterface

endmodule

endpackage
