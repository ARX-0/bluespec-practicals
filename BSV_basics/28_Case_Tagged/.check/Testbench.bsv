package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Tagged_IFC  dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(6)) i <- mkReg (0);

   // Values that wrap when doubled and when incremented.
   Bit #(8) x = {i [3:0], 4'hF};
   Maybe #(Bit #(8)) m = (i[4] == 1) ? tagged Valid x : tagged Invalid;

   mkAutoFSM (
      seq
         $display ("  32 cases, half Invalid, values chosen to wrap");
         while (i < 32) seq
            action
               Bit #(8) exp = isValid (m) ? (x << 1) : 0;
               let got = dut.doubleOrZero (m);
               ck.check (got == exp,
                  $format ("doubleOrZero(") + fshow (m)
                  + $format (") expected %0d, got %0d", exp, got));
            endaction
            action
               Maybe #(Bit #(8)) exp = isValid (m) ? tagged Valid (x + 1)
                                                   : tagged Invalid;
               let got = dut.incr (m);
               ck.check (got == exp,
                  $format ("incr(") + fshow (m) + $format (") expected ") + fshow (exp)
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
