package Testbench;

import StmtFSM :: *;
import Top     :: *;
import Checker :: *;

(* synthesize *)
module mkTestbench (Empty);

   Decode_IFC  dut <- mkTop;
   Checker_IFC ck  <- mkChecker (500);

   Reg #(Bit #(7)) i <- mkReg (0);

   // A raw word built so that all four opcodes and many rd/rs pairs appear.
   Bit #(10) raw = {i [1:0], i [5:2], ~i [5:2]};

   // The layout, spelled out by hand -- this is the specification.
   Instr exp = Instr { op: unpack (raw [9:8]),
                       rd: raw [7:4],
                       rs: raw [3:0] };

   Bit #(8) x = {2'b10, i [5:0]};
   Bit #(8) y = {i [5:0], 2'b01};

   Bit #(8) expExec = case (exp.op)
                         OpAdd: x + y;
                         OpSub: x - y;
                         OpAnd: x & y;
                         OpOr:  x | y;
                      endcase;

   mkAutoFSM (
      seq
         $display ("  64 instruction words, every opcode");
         while (i < 64) seq
            action
               let got = dut.decode (raw);
               ck.check (got == exp,
                  $format ("decode(%010b) expected ", raw) + fshow (exp)
                  + $format (", got ") + fshow (got));
            endaction
            action
               // encode must be the inverse of the reference decode
               let got = dut.encode (exp);
               ck.check (got == raw,
                  $format ("encode(") + fshow (exp)
                  + $format (") expected %010b, got %010b", raw, got));
            endaction
            action
               let got = dut.execute (exp.op, x, y);
               ck.check (got == expExec,
                  $format ("execute(") + fshow (exp.op)
                  + $format (", 0x%02h, 0x%02h) expected 0x%02h, got 0x%02h",
                            x, y, expExec, got));
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
