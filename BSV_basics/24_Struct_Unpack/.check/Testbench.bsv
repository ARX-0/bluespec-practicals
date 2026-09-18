package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Unpack_IFC  dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(6)) i <- mkReg (0);

   Bit #(16) raw = {i [3:0], ~i [3:0], i [3:0], 4'h9};

   // The layout, written out by hand -- this is the specification.
   Header exp = Header { tag: raw [15:12], len: raw [11:8], payload: raw [7:0] };

   mkAutoFSM (
      seq
         $display ("  16 raw words");
         while (i < 16) seq
            action
               let got = dut.fromBits (raw);
               ck.check (got == exp,
                  $format ("fromBits(0x%04h) expected ", raw) + fshow (exp)
                  + $format (", got ") + fshow (got));
            endaction
            action
               let got = dut.tagOf (raw);
               ck.check (got == exp.tag,
                  $format ("tagOf(0x%04h) expected 0x%01h, got 0x%01h",
                           raw, exp.tag, got));
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
