package Testbench;

import StmtFSM :: *;
import Vector  :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   Poly_IFC    dut <- mkTop;
   Poly_IFC    gld <- mkRef;
   Checker_IFC ck  <- mkChecker (5000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0014));
   Reg #(Bit #(16)) n <- mkReg (0);

   Bit #(3) bi = s[2:0];
   Bit #(2) pi = s[4:3];
   Bit #(8) bv = s[15:8];
   Pair     pv = Pair { a: s[19:16], b: (s[20] == 1) };

   mkAutoFSM (
      seq
         $display ("  200 randomised write/read rounds over both banks");
         while (n < 200) seq
            action
               dut.updByte (bi, bv);  gld.updByte (bi, bv);
               dut.updPair (pi, pv);  gld.updPair (pi, pv);
            endaction
            action
               // Read back the slots just written.
               Bool okB = (dut.subByte (bi) == gld.subByte (bi));
               Bool okP = (dut.subPair (pi) == gld.subPair (pi));
               ck.check (okB && okP,
                  $format ("round %0d: byte[%0d] exp %02h got %02h | pair[%0d] exp ",
                           n, bi, gld.subByte (bi), dut.subByte (bi), pi,
                           fshow (gld.subPair (pi)), " got ", fshow (dut.subPair (pi))));
            endaction
            action
               // And an unrelated slot, to catch a bank that writes everywhere.
               Bit #(3) other = bi + 1;
               ck.check (dut.subByte (other) == gld.subByte (other),
                  $format ("round %0d: byte[%0d] (untouched slot) exp %02h got %02h",
                           n, other, gld.subByte (other), dut.subByte (other)));
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
