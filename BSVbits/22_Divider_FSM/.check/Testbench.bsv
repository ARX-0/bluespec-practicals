package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   Div_IFC     dut <- mkTop;
   Div_IFC     gld <- mkRef;
   Checker_IFC ck  <- mkChecker (12000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0022));
   Reg #(Bit #(16)) n <- mkReg (0);

   // den is never 0. Round 0 forces the widest quotient: 65535 / 1.
   Bit #(16) num = (n == 0) ? 16'hFFFF : s[15:0];
   Bit #(8)  den = (n == 0) ? 8'd1     : (s[23:16] | 8'd1);

   mkAutoFSM (
      seq
         $display ("  60 divisions (65535 / 1 forced on round 0)");
         while (n < 60) seq
            action
               dut.start (num, den);
               gld.start (num, den);
            endaction
            action
               let a <- dut.result ();
               let b <- gld.result ();
               ck.check (a == b,
                  $format ("%0d / %0d: expected ", num, den, fshow (b),
                           " got ", fshow (a)));
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
