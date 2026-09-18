// Golden reference for problem 03 -- specification, not solution.
// Deliberately built from explicit bit loops rather than the library
// width-changing functions the problem wants you to find.
package Ref;
import Top :: *;

(* synthesize *)
module mkRef (Adder_IFC);

   method Bit #(9) add8 (Bit #(8) a, Bit #(8) b, Bit #(1) cin);
      // Ripple-carry, one bit at a time.
      Bit #(9) sum = 0;
      Bit #(1) c   = cin;
      for (Integer i = 0; i < 8; i = i + 1) begin
         Bit #(1) s = a[i] ^ b[i] ^ c;
         c = (a[i] & b[i]) | (a[i] & c) | (b[i] & c);
         sum[i] = s;
      end
      sum[8] = c;
      return sum;
   endmethod

   method Bit #(16) zext (Bit #(8) x);
      Bit #(16) r = 0;
      for (Integer i = 0; i < 8; i = i + 1) r[i] = x[i];
      return r;
   endmethod

   method Bit #(16) sext (Bit #(8) x);
      Bit #(16) r = 0;
      for (Integer i = 0; i < 8; i = i + 1)  r[i] = x[i];
      for (Integer i = 8; i < 16; i = i + 1) r[i] = x[7];
      return r;
   endmethod

   method Bit #(8) trunc (Bit #(16) x);
      Bit #(8) r = 0;
      for (Integer i = 0; i < 8; i = i + 1) r[i] = x[i];
      return r;
   endmethod

endmodule

endpackage
