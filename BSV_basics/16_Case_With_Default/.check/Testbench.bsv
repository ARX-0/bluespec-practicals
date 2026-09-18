package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Dflt_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(5)) i <- mkReg (0);

   Bit #(3) sel = i [2:0];
   Bit #(4) n   = i [3:0];

   mkAutoFSM (
      seq
         $display ("  all 8 sel values, all 16 nibbles");
         while (i < 16) seq
            action
               Bit #(8) exp = case (sel)
                                 3'd1: 8'hA1; 3'd2: 8'hB2; 3'd4: 8'hC4;
                                 default: 8'h00;
                              endcase;
               let got = dut.lookup (sel);
               ck.check (got == exp,
                  $format ("lookup(%0d) expected 0x%02h, got 0x%02h", sel, exp, got));
            endaction
            action
               Bit #(3) exp = case (True)
                                 (n[0] == 1): 0; (n[1] == 1): 1;
                                 (n[2] == 1): 2; (n[3] == 1): 3;
                                 default: 4;
                              endcase;
               let got = dut.firstSet (n);
               ck.check (got == exp,
                  $format ("firstSet(%04b) expected %0d, got %0d", n, exp, got));
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
