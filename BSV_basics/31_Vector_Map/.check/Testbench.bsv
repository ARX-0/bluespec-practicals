package Testbench;

import StmtFSM     :: *;
import Vector      :: *;
import BuildVector :: *;
import Top         :: *;
import Checker     :: *;

function Bit #(8) dbl (Bit #(8) x) = x << 1;
function Bool     nz (Bit #(8) x) = x != 0;

(* synthesize *)
module mkTestbench (Empty);

   Map_IFC     dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(6)) i <- mkReg (0);

   // Includes zeros and values that wrap when doubled.
   Vector #(4, Bit #(8)) v = vec (zeroExtend (i [3:0]),
                                  0,
                                  {i [3:0], 4'hF},
                                  8'h80);

   mkAutoFSM (
      seq
         $display ("  16 vectors, including zeros and values that wrap");
         while (i < 16) seq
            action
               Vector #(4, Bit #(8)) exp = map (dbl, v);
               let got = dut.doubleAll (v);
               ck.check (got == exp,
                  $format ("doubleAll(") + fshow (v) + $format (") expected ")
                  + fshow (exp) + $format (", got ") + fshow (got));
            endaction
            action
               Vector #(4, Bool) exp = map (nz, v);
               let got = dut.nonZero (v);
               ck.check (got == exp,
                  $format ("nonZero(") + fshow (v) + $format (") expected ")
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
