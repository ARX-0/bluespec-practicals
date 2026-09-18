package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Store_IFC   dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   mkAutoFSM (
      seq
         $display ("  the reset value must survive; nothing writes this register");
         action
            let got = dut.get;
            ck.check (got == 8'd42,
               $format ("get() at the first cycle expected 42, got %0d", got));
         endaction
         action
            let got = dut.get;
            ck.check (got == 8'd42,
               $format ("get() a cycle later expected 42, got %0d", got));
         endaction
         action
            let got = dut.get;
            ck.check (got == 8'd42,
               $format ("get() later still expected 42, got %0d", got));
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
