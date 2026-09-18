package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Q_IFC       dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   mkAutoFSM (
      seq
         $display ("  push four, then pop four -- oldest out first");
         action
            let got = dut.empty;
            ck.check (got == True,
               $format ("empty() on a fresh queue expected True, got ") + fshow (got));
         endaction
         action  dut.push (8'hA1);  endaction
         action  dut.push (8'hB2);  endaction
         action
            let got = dut.empty;
            ck.check (got == False,
               $format ("empty() with two items expected False, got ") + fshow (got));
         endaction
         action  dut.push (8'hC3);  endaction
         action  dut.push (8'hD4);  endaction
         action
            let got = dut.full;
            ck.check (got == True,
               $format ("full() with four items in a 4-deep queue expected True, got ")
               + fshow (got));
         endaction
         action
            let got <- dut.pop;
            ck.check (got == 8'hA1,
               $format ("first pop() expected 0xA1 (the oldest), got 0x%02h", got));
         endaction
         action
            let got <- dut.pop;
            ck.check (got == 8'hB2,
               $format ("second pop() expected 0xB2, got 0x%02h", got));
         endaction
         action
            let got <- dut.pop;
            ck.check (got == 8'hC3,
               $format ("third pop() expected 0xC3, got 0x%02h", got));
         endaction
         action
            let got <- dut.pop;
            ck.check (got == 8'hD4,
               $format ("fourth pop() expected 0xD4, got 0x%02h", got));
         endaction
         action
            let got = dut.empty;
            ck.check (got == True,
               $format ("empty() after popping everything expected True, got ")
               + fshow (got));
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
