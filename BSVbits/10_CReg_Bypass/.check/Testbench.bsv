package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Drain_IFC   dut <- mkTop;
   Drain_IFC   gld <- mkRef;
   Checker_IFC ck  <- mkChecker (2000);

   Reg #(Bit #(16)) n <- mkReg (0);

   mkAutoFSM (
      seq
         $display ("  160 cycles -- 40 drain events");
         while (n < 160) seq
            action
               Bool okC = (dut.current == gld.current);
               Bool okT = (dut.total   == gld.total);
               ck.check (okC && okT,
                  $format ("cycle %0d: current exp %0d got %0d | total exp %0d got %0d",
                           n, gld.current, dut.current, gld.total, dut.total));
               n <= n + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
