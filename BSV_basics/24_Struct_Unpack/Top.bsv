// ============================================================================
// 24 -- unpack into a Struct
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface or the
// typedef -- the checker shares the type with your module.
// ============================================================================

package Top;

//    [15:12] tag    [11:8] len    [7:0] payload
typedef struct {
   Bit #(4) tag;
   Bit #(4) len;
   Bit #(8) payload;
} Header deriving (Bits, Eq, FShow);

interface Unpack_IFC;
   // Sixteen raw bits -> a Header.
   method Header fromBits (Bit #(16) raw);

   // The tag field of those raw bits, without any bit indexing.
   method Bit #(4) tagOf (Bit #(16) raw);
endinterface

(* synthesize *)
module mkTop (Unpack_IFC);

   method Header fromBits (Bit #(16) raw);
      return Header { tag: 0, len: 0, payload: 0 };// TODO
   endmethod

   method Bit #(4) tagOf (Bit #(16) raw);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
