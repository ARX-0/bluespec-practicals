package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Init_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   mkAutoFSM (
      seq
         $display ("  each register must come up holding its own reset value");
         action
            let got = dut.a;
            ck.check (got == 8'd7, $format ("a() expected 7, got %0d", got));
         endaction
         action
            let got = dut.b;
            ck.check (got == 8'd200, $format ("b() expected 200, got %0d", got));
         endaction
         action
            let got = dut.flag;
            ck.check (got == True,
               $format ("flag() expected ") + fshow (True)
               + $format (", got ") + fshow (got));
         endaction
         action
            // and they stay put -- nothing writes them
            let got = dut.a;
            ck.check (got == 8'd7,
               $format ("a() a few cycles later expected 7, got %0d", got));
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
