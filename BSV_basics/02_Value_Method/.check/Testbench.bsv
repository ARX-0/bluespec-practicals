package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Wire_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(8)) i <- mkReg (0);

   Bit #(8) a = i;
   Bit #(8) b = i + 8'd100;

   mkAutoFSM (
      seq
         $display ("  driving a = 0,10,20..90 and b = a+100");
         while (i < 100) seq
            action
               let got = dut.same (a);
               ck.check (got == a, $format ("same(%0d) expected %0d, got %0d", a, a, got));
            endaction
            action
               let got = dut.second (a, b);
               ck.check (got == b, $format ("second(%0d,%0d) expected %0d, got %0d", a, b, b, got));
            endaction
            action
               i <= i + 10;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
