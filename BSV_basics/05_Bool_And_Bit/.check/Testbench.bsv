package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Bool_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(4)) i <- mkReg (0);

   // i[0] and i[1] drive the two Bools; i[2] decides whether a == b.
   Bool     p = (i[0] == 1);
   Bool     q = (i[1] == 1);
   Bit #(8) a = 8'd7;
   Bit #(8) b = (i[2] == 1) ? 8'd7 : 8'd9;

   mkAutoFSM (
      seq
         $display ("  exhaustive over p, q, and (a==b)");
         while (i < 8) seq
            action
               let got = dut.isEqual (a, b);
               ck.check (got == (a == b),
                  $format ("isEqual(%0d,%0d) expected ", a, b) + fshow (a == b)
                  + $format (", got ") + fshow (got));
            endaction
            action
               let got = dut.bothTrue (p, q);
               ck.check (got == (p && q),
                  $format ("bothTrue(") + fshow (p) + $format (",") + fshow (q)
                  + $format (") expected ") + fshow (p && q)
                  + $format (", got ") + fshow (got));
            endaction
            action
               let got = dut.notP (p);
               ck.check (got == (! p),
                  $format ("notP(") + fshow (p) + $format (") expected ") + fshow (! p)
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
