package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Lit_IFC     dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   mkAutoFSM (
      seq
         action
            let got = dut.hexLit;
            ck.check (got == 8'hF0, $format ("hexLit() expected 0xF0, got 0x%02h", got));
         endaction
         action
            let got = dut.decLit;
            ck.check (got == 8'd42, $format ("decLit() expected 42, got %0d", got));
         endaction
         action
            let got = dut.binLit;
            ck.check (got == 8'b0000_1111,
               $format ("binLit() expected 0000_1111, got %08b", got));
         endaction
         action
            let got = dut.allOnes;
            ck.check (got == 8'hFF, $format ("allOnes() expected 11111111, got %08b", got));
         endaction
         action
            let got = dut.zeros;
            ck.check (got == 8'h00, $format ("zeros() expected 00000000, got %08b", got));
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
