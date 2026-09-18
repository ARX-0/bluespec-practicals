package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Conv_IFC    dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(9)) i <- mkReg (0);

   Bool     p = (i[0] == 1);
   Bit #(1) c = i[0];
   Bit #(8) r = i [7:0];

   mkAutoFSM (
      seq
         $display ("  both Bool values, and all 256 byte patterns");
         while (i < 256) seq
            action
               let got = dut.toBit (p);
               ck.check (got == pack (p),
                  $format ("toBit(") + fshow (p) + $format (") expected %0d, got %0d",
                                                            pack (p), got));
            endaction
            action
               Bool exp = unpack (c);
               let got = dut.toBool (c);
               ck.check (got == exp,
                  $format ("toBool(%0d) expected ", c) + fshow (exp)
                  + $format (", got ") + fshow (got));
            endaction
            action
               UInt #(8) arg = unpack (r);
               let got = dut.uToBits (arg);
               ck.check (got == r,
                  $format ("uToBits(%0d) expected 0x%02h, got 0x%02h", r, r, got));
            endaction
            action
               UInt #(8) exp = unpack (r);
               let got = dut.bitsToU (r);
               ck.check (got == exp,
                  $format ("bitsToU(0x%02h) expected %0d, got %0d", r, exp, got));
            endaction
            action
               i <= i + 17;      // strides the byte space in 16 steps
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
