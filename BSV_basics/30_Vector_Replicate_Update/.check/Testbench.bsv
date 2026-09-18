package Testbench;

import StmtFSM     :: *;
import Vector      :: *;
import BuildVector :: *;
import Top         :: *;
import Checker     :: *;

(* synthesize *)
module mkTestbench (Empty);

   Fill_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(6)) i <- mkReg (0);

   Bit #(8) x = {4'h7, i [3:0]};
   Vector #(4, Bit #(8)) v = vec (8'h10, 8'h20, 8'h30, 8'h40);
   Bit #(2) idx = i [1:0];

   mkAutoFSM (
      seq
         $display ("  16 values, every index");
         while (i < 16) seq
            action
               Vector #(4, Bit #(8)) exp = replicate (x);
               let got = dut.allSame (x);
               ck.check (got == exp,
                  $format ("allSame(0x%02h) expected ", x) + fshow (exp)
                  + $format (", got ") + fshow (got));
            endaction
            action
               Vector #(4, Bit #(8)) exp = update (v, idx, x);
               let got = dut.setOne (v, idx, x);
               ck.check (got == exp,
                  $format ("setOne(v,%0d,0x%02h) expected ", idx, x) + fshow (exp)
                  + $format (", got ") + fshow (got));
            endaction
            action
               Vector #(4, Bit #(8)) exp = update (replicate (0), 0, x);
               let got = dut.onlyFirst (x);
               ck.check (got == exp,
                  $format ("onlyFirst(0x%02h) expected ", x) + fshow (exp)
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
