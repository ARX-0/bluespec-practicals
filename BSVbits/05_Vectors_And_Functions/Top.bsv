// ============================================================================
// 05 -- Vectors and Functions
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// The point of this problem is to stop writing bit loops and start writing
// map / fold. Every method below CAN be done with a `for` loop -- try to do
// it without one.
// ============================================================================

package Top;

import Vector :: *;

interface Vec_IFC;
   // How many bits of x are 1?  (0..8, so 4 bits of result)
   method Bit #(4) popcount (Bit #(8) x);

   // Reverse the bit order: 0b1100_0001 -> 0b1000_0011
   method Bit #(8) reverseBits (Bit #(8) x);

   // Largest element of the vector (unsigned).
   method Bit #(8) maxOf (Vector #(4, Bit #(8)) v);

   // Add 1 to every element (wrapping at 255).
   method Vector #(4, Bit #(8)) incAll (Vector #(4, Bit #(8)) v);
endinterface

(* synthesize *)
module mkTop (Vec_IFC);

   // You may define helper functions here, before the methods:
   //
   //    function Bit #(8) plus1 (Bit #(8) a) = a + 1;

   // TODO: your code here.

   method Bit #(4) popcount (Bit #(8) x);
      return 0;
   endmethod

   method Bit #(8) reverseBits (Bit #(8) x);
      return 0;
   endmethod

   method Bit #(8) maxOf (Vector #(4, Bit #(8)) v);
      return 0;
   endmethod

   method Vector #(4, Bit #(8)) incAll (Vector #(4, Bit #(8)) v);
      return replicate (0);
   endmethod

endmodule

endpackage
