package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Stop_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(8)) prev <- mkReg (0);

   mkAutoFSM (
      seq
         $display ("  must climb to 10, then stop -- the rule stops firing");
         action
            prev <= dut.count;
         endaction
         repeat (6) action
            let got = dut.count;
            Bit #(8) exp = (prev < 10) ? prev + 1 : 10;
            ck.check (got == exp,
               $format ("count(): after %0d expected %0d, got %0d", prev, exp, got));
            prev <= got;
         endaction

         repeat (20) noAction;         // let plenty of cycles go by

         action
            let got = dut.count;
            ck.check (got == 8'd10,
               $format ("count() should have settled at 10, got %0d", got));
         endaction
         action
            let got = dut.count;
            ck.check (got == 8'd10,
               $format ("count() should still be 10 (the guard is false), got %0d", got));
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
