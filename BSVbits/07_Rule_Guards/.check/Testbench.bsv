package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Sat_IFC     dut <- mkTop;
   Sat_IFC     gld <- mkRef;
   Checker_IFC ck  <- mkChecker (2000);

   Reg #(Bit #(16)) n <- mkReg (0);

   mkAutoFSM (
      seq
         $display ("  300 cycles -- long enough for every counter to saturate");
         while (n < 300) seq
            action
               Bool okU = (dut.up   == gld.up);
               Bool okD = (dut.down == gld.down);
               Bool okS = (dut.slow == gld.slow);
               ck.check (okU && okD && okS,
                  $format ("cycle %0d: up exp %0d got %0d | down exp %0d got %0d | slow exp %0d got %0d",
                           n, gld.up, dut.up, gld.down, dut.down, gld.slow, dut.slow));
               n <= n + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
