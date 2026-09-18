// Golden reference for problem 19 -- specification, not solution.
// A single deep FIFO with the whole function applied on entry. It defines
// the values and the ordering; it says nothing about pipelining.
package Ref;
import Top   :: *;
import FIFOF :: *;

(* synthesize *)
module mkRef (Pipe_IFC);

   FIFOF #(Bit #(16)) q <- mkSizedFIFOF (16);

   method Action put (Bit #(8) x);
      // Applied in the same WIDTHS as the staged version: stage 1 is
      // 8-bit, so x = 255 wraps to 0 before the multiply.
      Bit #(8)  s1 = x + 1;
      Bit #(16) s2 = zeroExtend (s1) * 3;
      q.enq (s2 ^ 16'hAAAA);
   endmethod

   method ActionValue #(Bit #(16)) get ();
      q.deq;
      return q.first;
   endmethod

   method Bool canPut () = q.notFull;
   method Bool canGet () = q.notEmpty;

endmodule

endpackage
