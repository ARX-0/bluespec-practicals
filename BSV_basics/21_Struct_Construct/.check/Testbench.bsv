package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Point_IFC   dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(5)) i <- mkReg (0);

   Bit #(8) a = {4'h7, i [3:0]};
   Bit #(8) b = {i [3:0], 4'h2};

   mkAutoFSM (
      seq
         $display ("  16 points");
         while (i < 16) seq
            action
               Point exp = Point { x: a, y: b };
               let got = dut.make (a, b);
               ck.check (got == exp,
                  $format ("make(0x%02h,0x%02h) expected ", a, b) + fshow (exp)
                  + $format (", got ") + fshow (got));
            endaction
            action
               Point exp = Point { x: 0, y: 0 };
               let got = dut.origin;
               ck.check (got == exp,
                  $format ("origin() expected ") + fshow (exp)
                  + $format (", got ") + fshow (got));
            endaction
            action
               Point exp = Point { x: a, y: a };
               let got = dut.diagonal (a);
               ck.check (got == exp,
                  $format ("diagonal(0x%02h) expected ", a) + fshow (exp)
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
