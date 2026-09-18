package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Sext_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(5)) i <- mkReg (0);

   Bit #(4) n  = i [3:0];
   Int #(8) si = unpack ({4'b1101, i [3:0]});   // negative, so sign matters

   mkAutoFSM (
      seq
         $display ("  nibble sweeps 0..15 (top half is negative)");
         while (i < 16) seq
            action
               Bit #(8) exp = signExtend (n);
               let got = dut.sext (n);
               ck.check (got == exp,
                  $format ("sext(%04b) expected %08b, got %08b", n, exp, got));
            endaction
            action
               Bit #(8) exp = zeroExtend (n);
               let got = dut.zext (n);
               ck.check (got == exp,
                  $format ("zext(%04b) expected %08b, got %08b", n, exp, got));
            endaction
            action
               Int #(16) exp = signExtend (si);
               let got = dut.sextI (si);
               ck.check (got == exp,
                  $format ("sextI(%0d) expected %0d, got %0d", si, exp, got));
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
