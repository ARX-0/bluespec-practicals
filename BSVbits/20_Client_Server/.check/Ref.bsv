// Golden reference for problem 20 -- specification, not solution.
// Uses the built-in `*` and a plain FIFO: one cycle, no state machine.
// It defines the arithmetic; your job is the multi-cycle protocol around it.
package Ref;
import Top           :: *;
import FIFOF         :: *;
import GetPut        :: *;
import ClientServer  :: *;

(* synthesize *)
module mkRef (Mul_IFC);

   FIFOF #(Bit #(16)) q <- mkSizedFIFOF (4);

   interface Server srv;
      interface Put request;
         method Action put (MulReq r);
            Bit #(16) x = zeroExtend (r.a);
            Bit #(16) y = zeroExtend (r.b);
            q.enq (x * y);
         endmethod
      endinterface
      interface Get response;
         method ActionValue #(Bit #(16)) get ();
            q.deq;
            return q.first;
         endmethod
      endinterface
   endinterface

endmodule

endpackage
