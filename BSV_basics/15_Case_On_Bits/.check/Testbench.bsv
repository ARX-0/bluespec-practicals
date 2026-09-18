package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Sel_IFC     dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(4)) i <- mkReg (0);

   Bit #(2) sel = i [1:0];
   Bit #(8) a = 8'hAA;  Bit #(8) b = 8'hBB;
   Bit #(8) c = 8'hCC;  Bit #(8) d = 8'hDD;

   mkAutoFSM (
      seq
         $display ("  all four select values");
         while (i < 4) seq
            action
               Bit #(8) exp = case (sel) 0: a; 1: b; 2: c; 3: d; endcase;
               let got = dut.mux4 (sel, a, b, c, d);
               ck.check (got == exp,
                  $format ("mux4(sel=%0d) expected 0x%02h, got 0x%02h", sel, exp, got));
            endaction
            action
               Bit #(4) exp = case (sel)
                                 0: 4'b0001; 1: 4'b0010;
                                 2: 4'b0100; 3: 4'b1000;
                              endcase;
               let got = dut.oneHot (sel);
               ck.check (got == exp,
                  $format ("oneHot(%0d) expected %04b, got %04b", sel, exp, got));
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
