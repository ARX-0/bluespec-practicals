package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Ticket_IFC  dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(8)) expected <- mkReg (0);

   mkAutoFSM (
      seq
         $display ("  each take() must hand out the next number in sequence");
         action
            let got = dut.peek;
            ck.check (got == 0,
               $format ("peek() before any take expected 0, got %0d", got));
         endaction
         repeat (20) action
            let got <- dut.take;
            ck.check (got == expected,
               $format ("take() expected %0d, got %0d", expected, got));
            expected <= expected + 1;
         endaction
         action
            let got = dut.peek;
            ck.check (got == expected,
               $format ("peek() after 20 takes expected %0d, got %0d", expected, got));
         endaction
         action
            let got = dut.peek;
            ck.check (got == expected,
               $format ("peek() must not advance anything; expected %0d, got %0d",
                        expected, got));
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
