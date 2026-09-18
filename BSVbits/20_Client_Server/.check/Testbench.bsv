// Checker for problem 20. One request at a time, waiting for each response.
// A multiplier that never returns stalls the FSM and trips the watchdog.
package Testbench;

import StmtFSM      :: *;
import GetPut       :: *;
import ClientServer :: *;
import Top          :: *;
import Ref          :: *;
import Checker      :: *;
import Stim         :: *;

(* synthesize *)
module mkTestbench (Empty);

   Mul_IFC     dut <- mkTop;
   Mul_IFC     gld <- mkRef;
   Checker_IFC ck  <- mkChecker (8000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0020));
   Reg #(Bit #(16)) n <- mkReg (0);

   // Round 0 forces the 255 x 255 corner, the largest product.
   Bit #(8) a = (n == 0) ? 8'hFF : s[7:0];
   Bit #(8) b = (n == 0) ? 8'hFF : s[15:8];
   MulReq   r = MulReq { a: a, b: b };

   mkAutoFSM (
      seq
         $display ("  80 multiplications (255 x 255 forced on round 0)");
         while (n < 80) seq
            action
               dut.srv.request.put (r);
               gld.srv.request.put (r);
            endaction
            action
               let x <- dut.srv.response.get ();
               let y <- gld.srv.response.get ();
               ck.check (x == y,
                  $format ("%0d * %0d: expected %0d, got %0d", a, b, y, x));
            endaction
            action
               s <= nextRand (s);
               n <= n + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
