package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Wire_IFC    dut <- mkTop;
   Wire_IFC    gld <- mkRef;
   Checker_IFC ck  <- mkChecker (2000);

   Reg #(Bit #(16)) n <- mkReg (0);

   mkAutoFSM (
      seq
         $display ("  200 cycles -- 50 pulses");
         while (n < 200) seq
            action
               Bool okT = (dut.tick == gld.tick);
               Bool okH = (dut.hits == gld.hits);
               Bool okL = (dut.last == gld.last);
               ck.check (okT && okH && okL,
                  $format ("cycle %0d: tick exp %0d got %0d | hits exp %0d got %0d | last exp %0d got %0d",
                           n, gld.tick, dut.tick, gld.hits, dut.hits, gld.last, dut.last));
               n <= n + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
