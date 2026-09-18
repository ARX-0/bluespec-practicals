// Golden reference for problem 05 -- specification, not solution.
// Written entirely with explicit `for` loops: correct, and exactly the style
// the problem is asking you to move away from.
package Ref;
import Top    :: *;
import Vector :: *;

(* synthesize *)
module mkRef (Vec_IFC);

   method Bit #(4) popcount (Bit #(8) x);
      Bit #(4) c = 0;
      for (Integer i = 0; i < 8; i = i + 1)
         if (x[i] == 1) c = c + 1;
      return c;
   endmethod

   method Bit #(8) reverseBits (Bit #(8) x);
      Bit #(8) r = 0;
      for (Integer i = 0; i < 8; i = i + 1)
         r[i] = x[7 - i];
      return r;
   endmethod

   method Bit #(8) maxOf (Vector #(4, Bit #(8)) v);
      Bit #(8) m = v[0];
      for (Integer i = 1; i < 4; i = i + 1)
         if (v[i] > m) m = v[i];
      return m;
   endmethod

   method Vector #(4, Bit #(8)) incAll (Vector #(4, Bit #(8)) v);
      Vector #(4, Bit #(8)) r = newVector;
      for (Integer i = 0; i < 4; i = i + 1)
         r[i] = v[i] + 1;
      return r;
   endmethod

endmodule

endpackage
