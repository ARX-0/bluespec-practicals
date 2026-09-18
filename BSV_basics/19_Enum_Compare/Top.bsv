// ============================================================================
// 19 -- Comparing Enum Values
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface or the
// typedef -- the checker shares the type with your module.
// ============================================================================

package Top;

typedef enum { RedLight, YellowLight, GreenLight }
   Light deriving (Bits, Eq, FShow);

interface Light_IFC;
   // Is this light red?
   method Bool isRed (Light l);

   // May traffic proceed? Only on green.
   method Bool isGo (Light l);

   // Are the two lights showing the same colour?
   method Bool sameLight (Light a, Light b);
endinterface

(* synthesize *)
module mkTop (Light_IFC);

   method Bool isRed (Light l);
      return False;             // TODO
   endmethod

   method Bool isGo (Light l);
      return False;             // TODO
   endmethod

   method Bool sameLight (Light a, Light b);
      return False;             // TODO
   endmethod

endmodule

endpackage
