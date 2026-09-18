// ============================================================================
// 35 -- Reset Values
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
// ============================================================================

package Top;

interface Init_IFC;
   method Bit #(8) a ();      // must read 7
   method Bit #(8) b ();      // must read 200
   method Bool     flag ();   // must read True
endinterface

(* synthesize *)
module mkTop (Init_IFC);

   // TODO: three state elements, with these reset values:
   //    a Reg #(Bit #(8)) starting at 7
   //    a Reg #(Bit #(8)) starting at 200
   //    a Reg #(Bool)     starting at True

   method Bit #(8) a ();
      return 0;                 // TODO
   endmethod

   method Bit #(8) b ();
      return 0;                 // TODO
   endmethod

   method Bool flag ();
      return False;             // TODO
   endmethod

endmodule

endpackage
