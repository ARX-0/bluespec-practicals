package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   Decode_IFC  dut <- mkTop;
   Decode_IFC  gld <- mkRef;
   Checker_IFC ck  <- mkChecker (3000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0004));
   Reg #(Bit #(16)) n <- mkReg (0);

   Bit #(10) raw = s[9:0];
   Bit #(8)  x   = s[17:10];
   Bit #(8)  y   = s[25:18];
   Opcode    op  = unpack (s[27:26]);

   mkAutoFSM (
      seq
         $display ("  160 randomised rounds");
         while (n < 160) seq
            action
               let got = dut.decode (raw);
               let exp = gld.decode (raw);
               ck.check (got == exp,
                  $format ("decode(%03h) expected ", raw, fshow (exp),
                           " got ", fshow (got)));
            endaction
            action
               // Round-trip: encode(decode(raw)) must give raw back.
               let i   = gld.decode (raw);
               let got = dut.encode (i);
               let exp = gld.encode (i);
               ck.check (got == exp,
                  $format ("encode(", fshow (i), ") expected %03h, got %03h", exp, got));
            endaction
            action
               let got = dut.execute (op, x, y);
               let exp = gld.execute (op, x, y);
               ck.check (got == exp,
                  $format ("execute(", fshow (op), ", %02h, %02h) expected %02h, got %02h",
                           x, y, exp, got));
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
