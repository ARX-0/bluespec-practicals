package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Local_IFC   dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(5)) i <- mkReg (0);

   // Pairs that overflow 8 bits, so a naive avg gets them wrong.
   Bit #(8) a = case (i)
                   0: 8'd200; 1: 8'd255; 2: 8'd0;   3: 8'd17;
                   4: 8'd128; 5: 8'd255; 6: 8'd90;  7: 8'd1;
                   default: 8'd0;
                endcase;
   Bit #(8) b = case (i)
                   0: 8'd100; 1: 8'd255; 2: 8'd0;   3: 8'd200;
                   4: 8'd128; 5: 8'd1;   6: 8'd10;  7: 8'd2;
                   default: 8'd0;
                endcase;

   Bit #(9) wide = zeroExtend (a) + zeroExtend (b);

   mkAutoFSM (
      seq
         $display ("  eight pairs, most of which overflow eight bits");
         while (i < 8) seq
            action
               Bit #(8) exp = (a + b) ^ (a - b);
               let got = dut.mix (a, b);
               ck.check (got == exp,
                  $format ("mix(%0d,%0d) expected 0x%02h, got 0x%02h", a, b, exp, got));
            endaction
            action
               Bit #(8) exp = truncate (wide >> 1);
               let got = dut.avg (a, b);
               ck.check (got == exp,
                  $format ("avg(%0d,%0d) expected %0d, got %0d", a, b, exp, got));
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
