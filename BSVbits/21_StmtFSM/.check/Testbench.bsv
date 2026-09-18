package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   Sum_IFC     dut <- mkTop;
   Sum_IFC     gld <- mkRef;
   Checker_IFC ck  <- mkChecker (12000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0021));
   Reg #(Bit #(16)) n <- mkReg (0);

   // Keep n modest so the runs stay short; force 0 and 1 as corner cases.
   Bit #(8) v = (n == 0) ? 0 : ((n == 1) ? 1 : (zeroExtend (s[5:0]) + 1));

   mkAutoFSM (
      seq
         $display ("  40 summations (n = 0 and n = 1 forced first)");
         while (n < 40) seq
            action
               dut.start (v);
               gld.start (v);
            endaction
            action
               // Blocks until the DUT's FSM has finished.
               let a <- dut.result ();
               let b <- gld.result ();
               ck.check (a == b,
                  $format ("sum 0..%0d: expected %0d, got %0d", v - 1, b, a));
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
