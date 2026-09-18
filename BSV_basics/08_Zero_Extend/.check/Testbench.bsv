package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Widen_IFC   dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(5)) i <- mkReg (0);

   Bit #(4) n = i [3:0];
   Bit #(8) a = {4'b1001, i [3:0]};

   mkAutoFSM (
      seq
         $display ("  nibble sweeps 0..15");
         while (i < 16) seq
            action
               let got = dut.widen8 (n);
               Bit #(8) exp = zeroExtend (n);
               ck.check (got == exp,
                  $format ("widen8(%04b) expected %08b, got %08b", n, exp, got));
            endaction
            action
               let got = dut.widen16 (a);
               Bit #(16) exp = zeroExtend (a);
               ck.check (got == exp,
                  $format ("widen16(0x%02h) expected 0x%04h, got 0x%04h", a, exp, got));
            endaction
            action
               let got = dut.addNibble (a, n);
               Bit #(8) exp = a + zeroExtend (n);
               ck.check (got == exp,
                  $format ("addNibble(0x%02h,%0d) expected 0x%02h, got 0x%02h",
                           a, n, exp, got));
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
