package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Ops_IFC     dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(5)) i <- mkReg (0);

   Bit #(4) a = i [3:0];
   Bit #(4) b = 4'b1010;

   mkAutoFSM (
      seq
         $display ("  a sweeps 0..15, b = 4'b1010");
         while (i < 16) seq
            action
               let got = dut.andOp (a, b);
               ck.check (got == (a & b),
                  $format ("andOp(%04b,%04b) expected %04b, got %04b", a, b, a & b, got));
            endaction
            action
               let got = dut.orOp (a, b);
               ck.check (got == (a | b),
                  $format ("orOp(%04b,%04b) expected %04b, got %04b", a, b, a | b, got));
            endaction
            action
               let got = dut.xorOp (a, b);
               ck.check (got == (a ^ b),
                  $format ("xorOp(%04b,%04b) expected %04b, got %04b", a, b, a ^ b, got));
            endaction
            action
               let got = dut.notOp (a);
               ck.check (got == (~a),
                  $format ("notOp(%04b) expected %04b, got %04b", a, ~a, got));
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
