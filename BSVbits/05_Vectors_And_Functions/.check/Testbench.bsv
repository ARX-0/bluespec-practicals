package Testbench;

import StmtFSM :: *;
import Vector  :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   Vec_IFC     dut <- mkTop;
   Vec_IFC     gld <- mkRef;
   Checker_IFC ck  <- mkChecker (3000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0005));
   Reg #(Bit #(16)) n <- mkReg (0);

   Bit #(8) x = s[7:0];

   // Four bytes of the seed word become the test vector.
   Vector #(4, Bit #(8)) v = unpack (s);

   mkAutoFSM (
      seq
         $display ("  160 randomised rounds");
         while (n < 160) seq
            action
               let got = dut.popcount (x);  let exp = gld.popcount (x);
               ck.check (got == exp,
                  $format ("popcount(%08b) expected %0d, got %0d", x, exp, got));
            endaction
            action
               let got = dut.reverseBits (x);  let exp = gld.reverseBits (x);
               ck.check (got == exp,
                  $format ("reverseBits(%08b) expected %08b, got %08b", x, exp, got));
            endaction
            action
               let got = dut.maxOf (v);  let exp = gld.maxOf (v);
               ck.check (got == exp,
                  $format ("maxOf(", fshow (v), ") expected %02h, got %02h", exp, got));
            endaction
            action
               let got = dut.incAll (v);  let exp = gld.incAll (v);
               ck.check (got == exp,
                  $format ("incAll(", fshow (v), ") expected ", fshow (exp),
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
