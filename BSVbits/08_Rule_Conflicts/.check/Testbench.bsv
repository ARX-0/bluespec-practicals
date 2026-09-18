package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Conflict_IFC dut <- mkTop;
   Conflict_IFC gld <- mkRef;
   Checker_IFC  ck  <- mkChecker (2000);

   Reg #(Bit #(16)) n <- mkReg (0);

   mkAutoFSM (
      seq
         $display ("  120 cycles -- 12 full wrap-arounds");
         while (n < 120) seq
            action
               Bool okC = (dut.count  == gld.count);
               Bool okR = (dut.resets == gld.resets);
               ck.check (okC && okR,
                  $format ("cycle %0d: count exp %0d got %0d | resets exp %0d got %0d",
                           n, gld.count, dut.count, gld.resets, dut.resets));
               n <= n + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
