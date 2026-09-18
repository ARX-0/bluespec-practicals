// Golden reference for problem 16 -- specification, not solution.
// A hand-rolled 8-deep buffer that applies the transform on the way in.
// Its CAPACITY differs from the two-FIFO pipeline deliberately: the
// testbench only ever drives an operation both modules are ready for, so
// timing may differ while the value SEQUENCE must not.
package Ref;
import Top    :: *;
import Vector :: *;

(* synthesize *)
module mkRef (Stage_IFC);

   Vector #(8, Reg #(Bit #(8))) d <- replicateM (mkReg (0));
   Reg #(Bit #(4))              c <- mkReg (0);

   method Action enq (Bit #(8) x) if (c < 8);
      for (Integer i = 0; i < 8; i = i + 1)
         if (fromInteger (i) == c) d[i] <= x + 1;
      c <= c + 1;
   endmethod

   method ActionValue #(Bit #(8)) deq () if (c > 0);
      for (Integer i = 0; i < 7; i = i + 1)
         d[i] <= d[i + 1];
      c <= c - 1;
      return d[0];
   endmethod

   method Bool notFull ()  = (c < 8);
   method Bool notEmpty () = (c > 0);

endmodule

endpackage
