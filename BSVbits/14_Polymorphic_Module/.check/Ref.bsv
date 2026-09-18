// Golden reference for problem 14 -- specification, not solution.
// Two separate hand-written banks, no polymorphism at all. This is what you
// would have had to write in Verilog, twice, and would have to write a third
// time for the next element type.
package Ref;
import Top    :: *;
import Vector :: *;

(* synthesize *)
module mkRef (Poly_IFC);

   Vector #(8, Reg #(Bit #(8))) bytes <- replicateM (mkReg (0));
   Vector #(4, Reg #(Pair))     pairs <- replicateM (mkReg (Pair { a: 0, b: False }));

   method Action updByte (Bit #(3) i, Bit #(8) v);
      bytes[i] <= v;
   endmethod

   method Bit #(8) subByte (Bit #(3) i) = bytes[i];

   method Action updPair (Bit #(2) i, Pair p);
      pairs[i] <= p;
   endmethod

   method Pair subPair (Bit #(2) i) = pairs[i];

endmodule

endpackage
