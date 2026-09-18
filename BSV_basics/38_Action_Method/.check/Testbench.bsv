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
         $display ("  set, then read back on the following cycle");
         action
            dut.set (8'h5A);
         endaction
         action
            let got = dut.get;
            ck.check (got == 8'h5A,
               $format ("after set(0x5A), get() expected 0x5A, got 0x%02h", got));
         endaction
         action
            dut.add (8'h03);
         endaction
         action
            let got = dut.get;
            ck.check (got == 8'h5D,
               $format ("after add(3), get() expected 0x5D, got 0x%02h", got));
         endaction
         action
            dut.set (8'hFF);
         endaction
         action
            dut.add (8'h02);            // 0xFF + 2 wraps to 0x01
         endaction
         action
            let got = dut.get;
            ck.check (got == 8'h01,
               $format ("after set(0xFF) then add(2), get() expected 0x01 (it wraps), got 0x%02h",
                        got));
         endaction
         action
            let got = dut.get;
            ck.check (got == 8'h01,
               $format ("with nothing called, get() should still be 0x01, got 0x%02h", got));
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
