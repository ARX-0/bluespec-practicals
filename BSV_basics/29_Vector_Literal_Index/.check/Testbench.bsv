package Testbench;

import StmtFSM     :: *;
import Vector      :: *;
import BuildVector :: *;
import Top         :: *;
import Checker     :: *;

(* synthesize *)
module mkTestbench (Empty);

   Vec_IFC     dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(6)) i <- mkReg (0);

   Bit #(8) a = {4'h1, i [3:0]};
   Bit #(8) b = {4'h2, i [3:0]};
   Bit #(8) c = {4'h3, i [3:0]};
   Bit #(8) d = {4'h4, i [3:0]};

   Vector #(4, Bit #(8)) v   = vec (a, b, c, d);
   Bit #(2)              idx = i [1:0];

   mkAutoFSM (
      seq
         $display ("  16 vectors, every index");
         while (i < 16) seq
            action
               let got = dut.build (a, b, c, d);
               ck.check (got == v,
                  $format ("build(...) expected ") + fshow (v)
                  + $format (", got ") + fshow (got));
            endaction
            action
               let got = dut.elemAt (v, idx);
               ck.check (got == v[idx],
                  $format ("elemAt(v,%0d) expected 0x%02h, got 0x%02h",
                           idx, v[idx], got));
            endaction
            action
               let got = dut.lastElem (v);
               ck.check (got == v[3],
                  $format ("lastElem(v) expected 0x%02h, got 0x%02h", v[3], got));
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
