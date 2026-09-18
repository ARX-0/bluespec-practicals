package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Trunc_IFC   dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(6)) i <- mkReg (0);

   Bit #(8)  a = {i [3:0], ~i [3:0]};
   Bit #(16) w = {8'hAB, a};

   mkAutoFSM (
      seq
         $display ("  16 patterns");
         while (i < 16) seq
            action
               Bit #(4) exp = a [3:0];
               let got = dut.low4 (a);
               ck.check (got == exp,
                  $format ("low4(%08b) expected %04b, got %04b", a, exp, got));
            endaction
            action
               Bit #(8) exp = w [7:0];
               let got = dut.low8 (w);
               ck.check (got == exp,
                  $format ("low8(0x%04h) expected 0x%02h, got 0x%02h", w, exp, got));
            endaction
            action
               Bit #(4) exp = a [7:4];
               let got = dut.high4 (a);
               ck.check (got == exp,
                  $format ("high4(%08b) expected %04b, got %04b", a, exp, got));
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
