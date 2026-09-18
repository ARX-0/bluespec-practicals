// ============================================================================
// 17 -- Functions
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// This time you also write code OUTSIDE the module: a function, at package
// level, that both methods call.
// ============================================================================

package Top;

// TODO: write a function here.
//
//    function Bit #(8) doubleIt (Bit #(8) x);
//       return x << 1;
//    endfunction

interface Fun_IFC;
   // 2*a + 2*b, using your function twice.
   method Bit #(8) twiceSum (Bit #(8) a, Bit #(8) b);

   // 4*a, by applying your function to its own result.
   method Bit #(8) quad (Bit #(8) a);
endinterface

(* synthesize *)
module mkTop (Fun_IFC);

   method Bit #(8) twiceSum (Bit #(8) a, Bit #(8) b);
      return 0;                 // TODO -- call your function twice
   endmethod

   method Bit #(8) quad (Bit #(8) a);
      return 0;                 // TODO -- call your function on its own result
   endmethod

endmodule

endpackage
