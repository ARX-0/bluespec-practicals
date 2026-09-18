// Golden reference for problem 13 -- specification, not solution.
// Stores the buffer as a single shift-down register bank with no head/tail
// pointers at all: items always live at slots 0..cnt-1 and deq shuffles
// everything down. Correct, obviously not how you would build one.
package Ref;
import Top    :: *;
import Vector :: *;

(* synthesize *)
module mkRef (Buf_IFC);

   Vector #(4, Reg #(Bit #(8))) d <- replicateM (mkReg (0));
   Reg #(Bit #(3))              c <- mkReg (0);

   method Action enq (Bit #(8) x) if (c < 4);
      // Append at the end.
      for (Integer i = 0; i < 4; i = i + 1)
         if (fromInteger (i) == c) d[i] <= x;
      c <= c + 1;
   endmethod

   method ActionValue #(Bit #(8)) deq () if (c > 0);
      // Take slot 0 and shuffle everything down one place.
      for (Integer i = 0; i < 3; i = i + 1)
         d[i] <= d[i + 1];
      c <= c - 1;
      return d[0];
   endmethod

   method Bool     notFull ()  = (c < 4);
   method Bool     notEmpty () = (c > 0);
   method Bit #(3) depth ()    = c;

endmodule

endpackage
