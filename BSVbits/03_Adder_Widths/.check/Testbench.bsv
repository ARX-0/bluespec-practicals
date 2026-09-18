package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   Adder_IFC   dut <- mkTop;
   Adder_IFC   gld <- mkRef;
   Checker_IFC ck  <- mkChecker (3000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0003));
   Reg #(Bit #(16)) n <- mkReg (0);

   Bit #(8)  a   = s[7:0];
   Bit #(8)  b   = s[15:8];
   Bit #(1)  cin = s[16];
   Bit #(16) w   = s[31:16];

   mkAutoFSM (
      seq
         $display ("  160 randomised rounds (plus the carry corner cases)");
         while (n < 160) seq
            action
               // Force the all-ones + carry corner on the first few rounds.
               Bit #(8) aa = (n == 0) ? 8'hFF : a;
               Bit #(8) bb = (n == 0) ? 8'hFF : b;
               Bit #(1) cc = (n == 0) ? 1'b1  : cin;
               let got = dut.add8 (aa, bb, cc);
               let exp = gld.add8 (aa, bb, cc);
               ck.check (got == exp,
                  $format ("add8(%02h + %02h + %0d) expected %03h, got %03h",
                           aa, bb, cc, exp, got));
            endaction
            action
               let got = dut.zext (a);  let exp = gld.zext (a);
               ck.check (got == exp,
                  $format ("zext(%02h) expected %04h, got %04h", a, exp, got));
            endaction
            action
               let got = dut.sext (a);  let exp = gld.sext (a);
               ck.check (got == exp,
                  $format ("sext(%02h) expected %04h, got %04h", a, exp, got));
            endaction
            action
               let got = dut.trunc (w); let exp = gld.trunc (w);
               ck.check (got == exp,
                  $format ("trunc(%04h) expected %02h, got %02h", w, exp, got));
            endaction
            action
               s <= nextRand (s);
               n <= n + 1;
            endaction
         endseq
         ck.done;
      endseq
   );

endmodule

endpackage
