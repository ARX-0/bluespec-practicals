package Testbench;

import StmtFSM :: *;
import Vector  :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   Score_IFC   dut <- mkTop;
   Score_IFC   gld <- mkRef;
   Checker_IFC ck  <- mkChecker (3000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0015));
   Reg #(Bit #(16)) n <- mkReg (0);

   Bit #(8) b = s[7:0];

   function Card mkCard (Bit #(2) su, Bit #(4) r) = Card { suit: unpack (su), rank: r };

   Card c0 = mkCard (s[1:0],   s[7:4]);
   Card c1 = mkCard (s[9:8],   s[15:12]);
   Card c2 = mkCard (s[17:16], s[23:20]);

   Vector #(3, Card) hand = cons (c0, cons (c1, cons (c2, nil)));

   mkAutoFSM (
      seq
         $display ("  160 randomised rounds over all three instances");
         while (n < 160) seq
            action
               let got = dut.scoreByte (b);  let exp = gld.scoreByte (b);
               ck.check (got == exp,
                  $format ("scoreByte(%02h) expected %0d, got %0d", b, exp, got));
            endaction
            action
               let got = dut.scoreCard (c0);  let exp = gld.scoreCard (c0);
               ck.check (got == exp,
                  $format ("scoreCard(", fshow (c0), ") expected %0d, got %0d", exp, got));
            endaction
            action
               let got = dut.scoreHand (hand);  let exp = gld.scoreHand (hand);
               ck.check (got == exp,
                  $format ("scoreHand(", fshow (hand), ") expected %0d, got %0d", exp, got));
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
