// Golden reference for problem 21 -- specification, not solution.
// Closed form, one cycle, no state machine at all: sum 0..n-1 = n(n-1)/2.
// It defines the answer; the exercise is expressing the ITERATION.
package Ref;
import Top   :: *;
import FIFOF :: *;

(* synthesize *)
module mkRef (Sum_IFC);

   FIFOF #(Bit #(16)) q <- mkSizedFIFOF (4);

   method Action start (Bit #(8) n);
      Bit #(16) w = zeroExtend (n);
      q.enq ((w * (w - 1)) >> 1);
   endmethod

   method Bool busy () = False;

   method ActionValue #(Bit #(16)) result ();
      q.deq;
      return q.first;
   endmethod

endmodule

endpackage
