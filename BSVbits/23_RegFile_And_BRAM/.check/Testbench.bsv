package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Ref     :: *;
import Checker :: *;
import Stim    :: *;

(* synthesize *)
module mkTestbench (Empty);

   Mem_IFC     dut <- mkTop;
   Mem_IFC     gld <- mkRef;
   Checker_IFC ck  <- mkChecker (10000);

   Reg #(Bit #(32)) s <- mkReg (seedFrom (32'h0000_0023));
   Reg #(Bit #(16)) n <- mkReg (0);
   Reg #(Bit #(9))  i <- mkReg (0);

   Bit #(4) ra = s[3:0];
   Bit #(8) ba = s[15:8];
   Bit #(8) dv = s[23:16];

   mkAutoFSM (
      seq
         // Both mkRegFileFull and mkBRAM1Server come up UNINITIALISED --
         // reading an address you never wrote gives an arbitrary value, and
         // the reference has no way to predict it. Write every location
         // first, so every later read is of defined data.
         $display ("  preloading all 256 BRAM and 16 RegFile locations");
         while (i < 256) seq
            action
               Bit #(8) a = truncate (i);
               Bit #(8) d = a ^ 8'h5A;
               dut.rfBramWrite (a, d);
               gld.rfBramWrite (a, d);
               if (i < 16) begin
                  dut.rfWrite (truncate (a), d);
                  gld.rfWrite (truncate (a), d);
               end
               i <= i + 1;
            endaction
         endseq

         $display ("  150 rounds over both memories");
         while (n < 150) seq
            action
               dut.rfWrite (ra, dv);       gld.rfWrite (ra, dv);
               dut.rfBramWrite (ba, dv);   gld.rfBramWrite (ba, dv);
            endaction
            action
               // RegFile: readable the same cycle, no request needed.
               ck.check (dut.rfRead (ra) == gld.rfRead (ra),
                  $format ("rf[%0d]: expected %02h, got %02h",
                           ra, gld.rfRead (ra), dut.rfRead (ra)));
            endaction
            action
               dut.bramReadReq (ba);
               gld.bramReadReq (ba);
            endaction
            action
               let a <- dut.bramReadResp ();
               let b <- gld.bramReadResp ();
               ck.check (a == b,
                  $format ("bram[%0d]: expected %02h, got %02h", ba, b, a));
            endaction
            action
               // An address we did not just write, to catch a memory that
               // returns the last value written regardless of address.
               Bit #(4) other = ra + 1;
               ck.check (dut.rfRead (other) == gld.rfRead (other),
                  $format ("rf[%0d] (other): expected %02h, got %02h",
                           other, gld.rfRead (other), dut.rfRead (other)));
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
