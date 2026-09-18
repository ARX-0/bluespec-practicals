package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Read_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(5)) i <- mkReg (0);

   Point p = Point { x: {4'h3, i [3:0]}, y: {i [3:0], 4'hE} };

   mkAutoFSM (
      seq
         $display ("  16 points");
         while (i < 16) seq
            action
               let got = dut.getX (p);
               ck.check (got == p.x,
                  $format ("getX(") + fshow (p)
                  + $format (") expected 0x%02h, got 0x%02h", p.x, got));
            endaction
            action
               let got = dut.getY (p);
               ck.check (got == p.y,
                  $format ("getY(") + fshow (p)
                  + $format (") expected 0x%02h, got 0x%02h", p.y, got));
            endaction
            action
               let got = dut.sumXY (p);
               ck.check (got == (p.x + p.y),
                  $format ("sumXY(") + fshow (p)
                  + $format (") expected 0x%02h, got 0x%02h", p.x + p.y, got));
            endaction
            action
               Point exp = Point { x: p.y, y: p.x };
               let got = dut.swapXY (p);
               ck.check (got == exp,
                  $format ("swapXY(") + fshow (p) + $format (") expected ") + fshow (exp)
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
