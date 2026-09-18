package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Light_IFC   dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(5)) i <- mkReg (0);

   Light a = case (i [1:0]) 0: RedLight; 1: YellowLight; default: GreenLight; endcase;
   Light b = case (i [3:2]) 0: RedLight; 1: YellowLight; default: GreenLight; endcase;

   mkAutoFSM (
      seq
         $display ("  every pair of lights");
         while (i < 16) seq
            action
               let got = dut.isRed (a);
               ck.check (got == (a == RedLight),
                  $format ("isRed(") + fshow (a) + $format (") expected ")
                  + fshow (a == RedLight) + $format (", got ") + fshow (got));
            endaction
            action
               let got = dut.isGo (a);
               ck.check (got == (a == GreenLight),
                  $format ("isGo(") + fshow (a) + $format (") expected ")
                  + fshow (a == GreenLight) + $format (", got ") + fshow (got));
            endaction
            action
               let got = dut.sameLight (a, b);
               ck.check (got == (a == b),
                  $format ("sameLight(") + fshow (a) + $format (",") + fshow (b)
                  + $format (") expected ") + fshow (a == b)
                  + $format (", got ") + fshow (got));
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
