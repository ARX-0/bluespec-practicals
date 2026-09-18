// Checker for problem 02. Exhaustive on the mux select, random on the data.
package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   Types_IFC   dut <- mkTop;
   Types_IFC   gld <- mkRef;
   Checker_IFC ck  <- mkChecker (2000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0002));
   Reg #(Bit #(16)) n <- mkReg (0);

   // Derive this round's operands from the current seed word.
   Bit #(8) a  = s[7:0];
   Bit #(8) b  = s[15:8];
   Bit #(8) c  = s[23:16];
   Bit #(8) d  = s[31:24];
   Bit #(2) sl = s[9:8];

   mkAutoFSM (
      seq
         $display ("  128 randomised rounds");
         while (n < 128) seq
            action
               let got = dut.mux4 (sl, a, b, c, d);
               let exp = gld.mux4 (sl, a, b, c, d);
               ck.check (got == exp,
                  $format ("mux4(sel=%0d, %02h %02h %02h %02h) expected %02h, got %02h",
                           sl, a, b, c, d, exp, got));
            endaction
            action
               let got = dut.swapNibbles (a);
               let exp = gld.swapNibbles (a);
               ck.check (got == exp,
                  $format ("swapNibbles(%02h) expected %02h, got %02h", a, exp, got));
            endaction
            action
               let got = dut.ugt (a, b);
               let exp = gld.ugt (a, b);
               ck.check (got == exp,
                  $format ("ugt(%0d, %0d) expected ", a, b, fshow (exp),
                           " got ", fshow (got)));
            endaction
            action
               let got = dut.sgt (a, b);
               let exp = gld.sgt (a, b);
               Int #(8) ia = unpack (a);  Int #(8) ib = unpack (b);
               ck.check (got == exp,
                  $format ("sgt(%0d, %0d) expected ", ia, ib, fshow (exp),
                           " got ", fshow (got)));
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
