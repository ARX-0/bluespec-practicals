package Testbench;

import StmtFSM     :: *;
import Vector      :: *;
import BuildVector :: *;
import Top         :: *;
import Checker     :: *;

function Bool nz (Bit #(8) x) = x != 0;

(* synthesize *)
module mkTestbench (Empty);

   Fold_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(6)) i <- mkReg (0);

   // Element 1 is zero for the first half of the sweep, non-zero after.
   Vector #(4, Bit #(8)) v = vec ({4'h3, i [3:0]},
                                  (i < 8) ? 0 : 8'h55,
                                  {i [3:0], 4'h8},
                                  8'hC0);

   mkAutoFSM (
      seq
         $display ("  16 vectors, half containing a zero");
         while (i < 16) seq
            action
               Bit #(8) exp = fold (\+ , v);
               let got = dut.total (v);
               ck.check (got == exp,
                  $format ("total(") + fshow (v)
                  + $format (") expected %0d, got %0d", exp, got));
            endaction
            action
               Bit #(8) exp = fold (max, v);
               let got = dut.biggest (v);
               ck.check (got == exp,
                  $format ("biggest(") + fshow (v)
                  + $format (") expected %0d, got %0d", exp, got));
            endaction
            action
               Bool exp = fold (\&& , map (nz, v));
               let got = dut.allNonZero (v);
               ck.check (got == exp,
                  $format ("allNonZero(") + fshow (v) + $format (") expected ")
                  + fshow (exp) + $format (", got ") + fshow (got));
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
