// Golden reference for problem 24 -- specification, not solution.
// Registers, combinational read, transform applied at request time. No
// latency to design around, so it says nothing about how to split a stage.
package Ref;
import Top    :: *;
import Vector :: *;
import FIFOF  :: *;

(* synthesize *)
module mkRef (MemPipe_IFC);

   Vector #(256, Reg #(Bit #(8))) m <- replicateM (mkReg (0));
   FIFOF #(Bit #(8)) outQ <- mkSizedFIFOF (8);

   method Action writeMem (Bit #(8) a, Bit #(8) d);
      m[a] <= d;
   endmethod

   method Action load (Bit #(8) a);
      outQ.enq (m[a] + 1);
   endmethod

   method ActionValue #(Bit #(8)) loadResult ();
      outQ.deq;
      return outQ.first;
   endmethod

endmodule

endpackage
