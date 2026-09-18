package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Swap_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(8)) sa <- mkReg (0);
   Reg #(Bit #(8)) sb <- mkReg (0);

   mkAutoFSM (
      seq
         $display ("  the two registers must exchange contents every cycle");
         action
            let a = dut.getA;
            let b = dut.getB;
            ck.check ((a == 8'h11) && (b == 8'h22),
               $format ("at reset expected getA=0x11 getB=0x22, got 0x%02h and 0x%02h",
                        a, b));
            sa <= a;  sb <= b;
         endaction
         repeat (20) action
            let a = dut.getA;
            let b = dut.getB;
            // One check covering both, so the whole comparison is one cycle.
            ck.check ((a == sb) && (b == sa),
               $format ("after (0x%02h,0x%02h) expected (0x%02h,0x%02h), got (0x%02h,0x%02h)",
                        sa, sb, sb, sa, a, b));
            sa <= a;  sb <= b;
         endaction
         ck.done;
      endseq
   );

endmodule

endpackage
