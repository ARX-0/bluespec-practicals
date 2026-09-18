// ============================================================================
// 14 -- Polymorphic modules and provisos
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interfaces.
//
// You write mkBank ONCE. mkTop then instantiates it twice, at two different
// sizes AND two different element types. That reuse is the whole point.
// ============================================================================

package Top;

import Vector :: *;

// A struct, to prove the bank really is element-type-generic.
typedef struct {
   Bit #(4) a;
   Bool     b;
} Pair deriving (Bits, Eq, FShow);

// A bank of n registers holding values of type t.
//   `numeric type n` -- a compile-time NUMBER (a size)
//   `type t`         -- a compile-time TYPE
interface Bank_IFC #(numeric type n, type t);
   method Action upd (Bit #(TLog #(n)) idx, t v);
   method t      sub (Bit #(TLog #(n)) idx);
endinterface

// ---------------------------------------------------------------------------
// TODO 1: implement the polymorphic bank.
//
// Note there is NO (* synthesize *) here -- a polymorphic module cannot have
// one, because there is no single piece of hardware to name until it is
// instantiated at concrete types.
//
// You will need a proviso. `bsc` will tell you exactly which one if you
// leave it out; read the error, it is a good one.
// ---------------------------------------------------------------------------

module mkBank (Bank_IFC #(n, t));

   // TODO: your code here.

   method Action upd (Bit #(TLog #(n)) idx, t v);
      noAction;
   endmethod

   method t sub (Bit #(TLog #(n)) idx);
      return ?;
   endmethod

endmodule

// ---------------------------------------------------------------------------
// The concrete top. Do not change this interface.
// ---------------------------------------------------------------------------

interface Poly_IFC;
   method Action     updByte (Bit #(3) i, Bit #(8) v);
   method Bit #(8)   subByte (Bit #(3) i);
   method Action     updPair (Bit #(2) i, Pair p);
   method Pair       subPair (Bit #(2) i);
endinterface

(* synthesize *)
module mkTop (Poly_IFC);

   // TODO 2: instantiate your bank twice, at different sizes and types.
   //
   //    Bank_IFC #(8, Bit #(8)) bytes <- mkBank;
   //    Bank_IFC #(4, Pair)     pairs <- mkBank;
   //
   // then wire the four methods straight through to them.

   method Action updByte (Bit #(3) i, Bit #(8) v);
      noAction;
   endmethod

   method Bit #(8) subByte (Bit #(3) i);
      return 0;
   endmethod

   method Action updPair (Bit #(2) i, Pair p);
      noAction;
   endmethod

   method Pair subPair (Bit #(2) i);
      return Pair { a: 0, b: False };
   endmethod

endmodule

endpackage
