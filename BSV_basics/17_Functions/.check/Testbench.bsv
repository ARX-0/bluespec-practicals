package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Fun_IFC     dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(6)) i <- mkReg (0);

   Bit #(8) a = zeroExtend (i [3:0]) * 17;      // 0, 17, 34, ... 255
   Bit #(8) b = 8'd90;

   mkAutoFSM (
      seq
         $display ("  16 values, including ones that wrap at 8 bits");
         while (i < 16) seq
            action
               Bit #(8) exp = (a << 1) + (b << 1);
               let got = dut.twiceSum (a, b);
               ck.check (got == exp,
                  $format ("twiceSum(%0d,%0d) expected %0d, got %0d", a, b, exp, got));
            endaction
            action
               Bit #(8) exp = a << 2;
               let got = dut.quad (a);
               ck.check (got == exp,
                  $format ("quad(%0d) expected %0d, got %0d", a, exp, got));
            endaction
            action
               i <= i + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
