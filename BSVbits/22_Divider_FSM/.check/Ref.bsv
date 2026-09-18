// Golden reference for problem 22 -- specification, not solution.
// Uses the built-in / and %, one cycle. Defines the arithmetic; says
// nothing about how to sequence it.
package Ref;
import Top   :: *;
import FIFOF :: *;

(* synthesize *)
module mkRef (Div_IFC);

   FIFOF #(DivResult) q <- mkSizedFIFOF (4);

   method Action start (Bit #(16) num, Bit #(8) den);
      Bit #(16) d = zeroExtend (den);
      q.enq (DivResult { quo: num / d, rem: num % d });
   endmethod

   method ActionValue #(DivResult) result ();
      q.deq;
      return q.first;
   endmethod

endmodule

endpackage
