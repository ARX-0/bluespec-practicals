// ============================================================================
// 31 -- map
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// You will need a function again (problem 17). Write it at package level.
// ============================================================================

package Top;

import Vector      :: *;
import BuildVector :: *;

// TODO: two functions here -- one for doubleAll to map, one for nonZero.


interface Map_IFC;
   // Every element doubled.
   method Vector #(4, Bit #(8)) doubleAll (Vector #(4, Bit #(8)) v);

   // True in each position where the element is not zero.
   method Vector #(4, Bool) nonZero (Vector #(4, Bit #(8)) v);
endinterface

(* synthesize *)
module mkTop (Map_IFC);

   method Vector #(4, Bit #(8)) doubleAll (Vector #(4, Bit #(8)) v);
      return v;                 // TODO
   endmethod

   method Vector #(4, Bool) nonZero (Vector #(4, Bit #(8)) v);
      return replicate (False); // TODO
   endmethod

endmodule

endpackage
