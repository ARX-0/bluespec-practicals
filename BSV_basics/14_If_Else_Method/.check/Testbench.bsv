package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Cond_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(5)) i <- mkReg (0);

   // Values that straddle both boundaries, and both sides of zero.
   Bit #(8) x = case (i)
                   0: 8'd0;   1: 8'd9;   2: 8'd10;  3: 8'd11;
                   4: 8'd99;  5: 8'd100; 6: 8'd101; 7: 8'd255;
                   default: 8'd0;
                endcase;
   Int #(8) s = case (i)
                   0: -128; 1: -7; 2: -1; 3: 0;
                   4: 1;    5: 7;  6: 100; 7: 127;
                   default: 0;
                endcase;

   mkAutoFSM (
      seq
         $display ("  eight values around each boundary");
         while (i < 8) seq
            action
               Bit #(2) exp = (x < 10) ? 0 : ((x < 100) ? 1 : 2);
               let got = dut.band (x);
               ck.check (got == exp,
                  $format ("band(%0d) expected %0d, got %0d", x, exp, got));
            endaction
            action
               Int #(8) exp = (s < 0) ? -1 : ((s > 0) ? 1 : 0);
               let got = dut.signOf (s);
               ck.check (got == exp,
                  $format ("signOf(%0d) expected %0d, got %0d", s, exp, got));
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
