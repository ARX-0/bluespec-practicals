// Checker for problem 18. Feeds both chains the same values and compares the
// output sequence. Capacities differ, so the testbench never assumes when a
// result is ready -- only that the values arrive in order and correct.
package Testbench;

import StmtFSM :: *;
import GetPut  :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   Chain_IFC   dut <- mkTop;
   Chain_IFC   gld <- mkRef;
   Checker_IFC ck  <- mkChecker (8000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0018));
   Reg #(Bit #(16)) n <- mkReg (0);

   Bit #(8) v = s[7:0];

   mkAutoFSM (
      seq
         $display ("  100 values through the chain, one at a time");
         while (n < 100) seq
            action
               dut.request.put (v);
               gld.request.put (v);
            endaction
            action
               let a <- dut.response.get ();
               let b <- gld.response.get ();
               ck.check (a == b,
                  $format ("in %02h: expected %0d, got %0d", v, b, a));
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
