// Golden reference for problem 23 -- specification, not solution.
// Both memories modelled as plain register banks, with the BRAM's response
// routed through a FIFO so the request/response shape is preserved. It
// defines WHAT is stored, not which library module to use.
package Ref;
import Top    :: *;
import Vector :: *;
import FIFOF  :: *;

(* synthesize *)
module mkRef (Mem_IFC);

   Vector #(16,  Reg #(Bit #(8))) rf <- replicateM (mkReg (0));
   Vector #(256, Reg #(Bit #(8))) bm <- replicateM (mkReg (0));
   FIFOF #(Bit #(8)) respQ <- mkFIFOF;

   method Action rfWrite (Bit #(4) a, Bit #(8) d);
      rf[a] <= d;
   endmethod

   method Bit #(8) rfRead (Bit #(4) a) = rf[a];

   method Action rfBramWrite (Bit #(8) a, Bit #(8) d);
      bm[a] <= d;
   endmethod

   method Action bramReadReq (Bit #(8) a);
      respQ.enq (bm[a]);
   endmethod

   method ActionValue #(Bit #(8)) bramReadResp ();
      respQ.deq;
      return respQ.first;
   endmethod

endmodule

endpackage
