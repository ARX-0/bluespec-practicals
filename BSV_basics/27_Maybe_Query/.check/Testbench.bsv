package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Query_IFC   dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(6)) i <- mkReg (0);

   Bit #(8) x = {4'h6, i [3:0]};
   Bit #(8) d = 8'hEE;
   Maybe #(Bit #(8)) m = (i[4] == 1) ? tagged Valid x : tagged Invalid;

   mkAutoFSM (
      seq
         $display ("  32 cases, half of them Invalid");
         while (i < 32) seq
            action
               let got = dut.valid (m);
               ck.check (got == isValid (m),
                  $format ("valid(") + fshow (m) + $format (") expected ")
                  + fshow (isValid (m)) + $format (", got ") + fshow (got));
            endaction
            action
               Bit #(8) exp = fromMaybe (0, m);
               let got = dut.orZero (m);
               ck.check (got == exp,
                  $format ("orZero(") + fshow (m)
                  + $format (") expected 0x%02h, got 0x%02h", exp, got));
            endaction
            action
               Bit #(8) exp = fromMaybe (d, m);
               let got = dut.orElse (m, d);
               ck.check (got == exp,
                  $format ("orElse(") + fshow (m)
                  + $format (",0x%02h) expected 0x%02h, got 0x%02h", d, exp, got));
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
