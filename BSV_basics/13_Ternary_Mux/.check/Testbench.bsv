package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Mux_IFC     dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(6)) i <- mkReg (0);

   Bool     sel = (i[0] == 1);
   Bit #(1) selb = i[0];
   Bit #(8) a   = {4'h5, i [3:0]};
   Bit #(8) b   = {i [3:0], 4'hA};

   mkAutoFSM (
      seq
         $display ("  32 combinations of sel and operands");
         while (i < 32) seq
            action
               Bit #(8) exp = sel ? b : a;
               let got = dut.mux2 (sel, a, b);
               ck.check (got == exp,
                  $format ("mux2(") + fshow (sel)
                  + $format (",0x%02h,0x%02h) expected 0x%02h, got 0x%02h", a, b, exp, got));
            endaction
            action
               Bit #(8) exp = (selb == 1) ? b : a;
               let got = dut.mux2b (selb, a, b);
               ck.check (got == exp,
                  $format ("mux2b(%0d,0x%02h,0x%02h) expected 0x%02h, got 0x%02h",
                           selb, a, b, exp, got));
            endaction
            action
               Bit #(8) exp = (a > b) ? a : b;
               let got = dut.maxOf (a, b);
               ck.check (got == exp,
                  $format ("maxOf(%0d,%0d) expected %0d, got %0d", a, b, exp, got));
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
