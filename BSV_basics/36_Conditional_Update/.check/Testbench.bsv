package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Wrap_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(8)) prev <- mkReg (0);

   mkAutoFSM (
      seq
         $display ("  must count 0..9 and wrap; 10 must never appear");
         action
            prev <= dut.count;
         endaction
         repeat (40) action
            let got = dut.count;
            Bit #(8) exp = (prev == 9) ? 0 : prev + 1;
            ck.check (got == exp,
               $format ("count(): after %0d expected %0d, got %0d", prev, exp, got));
            prev <= got;
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
