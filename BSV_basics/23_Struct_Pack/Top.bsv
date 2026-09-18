// ============================================================================
// 23 -- pack on a Struct
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface or the
// typedef -- the checker shares the type with your module.
// ============================================================================

package Top;

// Three fields, 4 + 4 + 8 = 16 bits.
// The FIRST field lands in the HIGHEST bits:
//    [15:12] tag    [11:8] len    [7:0] payload
typedef struct {
   Bit #(4) tag;
   Bit #(4) len;
   Bit #(8) payload;
} Header deriving (Bits, Eq, FShow);

interface Pack_IFC;
   // The whole header as sixteen raw bits.
   method Bit #(16) toBits (Header h);

   // The top byte of those bits -- WITHOUT naming any index.
   method Bit #(8) topByte (Header h);
endinterface

(* synthesize *)
module mkTop (Pack_IFC);

   method Bit #(16) toBits (Header h);
      return 0;                 // TODO
   endmethod

   method Bit #(8) topByte (Header h);
      return 0;                 // TODO
   endmethod

endmodule

endpackage
