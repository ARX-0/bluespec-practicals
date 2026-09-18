package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Slice_IFC   dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(6)) i <- mkReg (0);

   Bit #(8) a  = {i [3:0], ~i [3:0]};
   Bit #(4) hi = i [3:0];
   Bit #(4) lo = 4'hC;

   mkAutoFSM (
      seq
         $display ("  16 patterns");
         while (i < 16) seq
            action
               let got = dut.high4 (a);
               ck.check (got == a [7:4],
                  $format ("high4(%08b) expected %04b, got %04b", a, a [7:4], got));
            endaction
            action
               let got = dut.bit3 (a);
               ck.check (got == a [3],
                  $format ("bit3(%08b) expected %0d, got %0d", a, a [3], got));
            endaction
            action
               let got = dut.joinNibbles (hi, lo);
               ck.check (got == {hi, lo},
                  $format ("joinNibbles(%04b,%04b) expected %08b, got %08b",
                           hi, lo, {hi, lo}, got));
            endaction
            action
               let got = dut.swapHalves (a);
               ck.check (got == {a [3:0], a [7:4]},
                  $format ("swapHalves(%08b) expected %08b, got %08b",
                           a, {a [3:0], a [7:4]}, got));
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
