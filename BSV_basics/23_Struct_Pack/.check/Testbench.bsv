package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Pack_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(5)) i <- mkReg (0);

   Header h = Header { tag: i [3:0], len: ~i [3:0], payload: {i [3:0], 4'hC} };

   mkAutoFSM (
      seq
         $display ("  16 headers; first field must land in the high bits");
         while (i < 16) seq
            action
               // Written out by hand -- this is the layout your pack must match.
               Bit #(16) exp = {h.tag, h.len, h.payload};
               let got = dut.toBits (h);
               ck.check (got == exp,
                  $format ("toBits(") + fshow (h)
                  + $format (") expected 0x%04h, got 0x%04h", exp, got));
            endaction
            action
               Bit #(8) exp = {h.tag, h.len};
               let got = dut.topByte (h);
               ck.check (got == exp,
                  $format ("topByte(") + fshow (h)
                  + $format (") expected 0x%02h, got 0x%02h", exp, got));
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
