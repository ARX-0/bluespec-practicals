// Golden reference for problem 02 -- the specification, not the solution.
package Ref;
import Top :: *;

(* synthesize *)
module mkRef (Types_IFC);

   method Bit #(8) mux4 (Bit #(2) sel,
                         Bit #(8) d0, Bit #(8) d1, Bit #(8) d2, Bit #(8) d3);
      if      (sel == 0) return d0;
      else if (sel == 1) return d1;
      else if (sel == 2) return d2;
      else               return d3;
   endmethod

   method Bit #(8) swapNibbles (Bit #(8) x);
      Bit #(8) r = 0;
      for (Integer i = 0; i < 4; i = i + 1) begin
         r[i]     = x[i + 4];
         r[i + 4] = x[i];
      end
      return r;
   endmethod

   method Bool ugt (Bit #(8) a, Bit #(8) b);
      // Compare as plain natural numbers, via the unsigned-integer type.
      UInt #(8) ua = unpack (a);
      UInt #(8) ub = unpack (b);
      return ua > ub;
   endmethod

   method Bool sgt (Bit #(8) a, Bit #(8) b);
      // Reference: split off the sign bit and reason about it explicitly.
      Bit #(1) sa = a[7];  Bit #(1) sb = b[7];
      if (sa != sb) return (sa == 0);          // positive beats negative
      else          return (a > b);            // same sign: magnitudes order correctly
   endmethod

endmodule

endpackage
