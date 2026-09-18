package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Count_IFC   dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   // What the counter read on the previous cycle.
   Reg #(Bit #(8)) prev <- mkReg (0);

   mkAutoFSM (
      seq
         $display ("  the counter must advance by exactly one every cycle");
         action
            prev <= dut.count;          // first sample, nothing to compare yet
         endaction
         repeat (30) action
            let got = dut.count;
            ck.check (got == (prev + 1),
               $format ("count() expected %0d (one more than last cycle's %0d), got %0d",
                        prev + 1, prev, got));
            prev <= got;
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
