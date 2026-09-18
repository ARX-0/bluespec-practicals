// ============================================================================
// 23 -- RegFile and BRAM: two kinds of memory
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// The difference that matters is READ LATENCY. A RegFile answers this
// cycle; a BRAM answers next cycle, so it needs a request/response split.
// That split is why memory shows up as a Server (problem 20).
// ============================================================================

package Top;

import RegFile       :: *;
import BRAM          :: *;
import DefaultValue  :: *;
import GetPut        :: *;
import ClientServer  :: *;

interface Mem_IFC;
   // ---- RegFile side: 16 entries, COMBINATIONAL read ----
   method Action   rfWrite (Bit #(4) a, Bit #(8) d);
   method Bit #(8) rfRead  (Bit #(4) a);        // same cycle, no request

   // ---- BRAM side: 256 entries, ONE CYCLE of read latency ----
   method Action rfBramWrite (Bit #(8) a, Bit #(8) d);
   method Action bramReadReq (Bit #(8) a);      // ask...
   method ActionValue #(Bit #(8)) bramReadResp (); // ...collect next cycle
endinterface

(* synthesize *)
module mkTop (Mem_IFC);

   // TODO: your code here.
   //
   // RegFile:
   //    RegFile #(Bit #(4), Bit #(8)) rf <- mkRegFileFull;
   //    rf.upd (a, d);     -- write
   //    rf.sub (a)         -- read, combinational
   //
   // BRAM:
   //    BRAM_Configure cfg = defaultValue;
   //    cfg.memorySize = 256;
   //    BRAM1Port #(Bit #(8), Bit #(8)) bram <- mkBRAM1Server (cfg);
   //
   //    bram.portA.request.put (BRAMRequest {
   //       write:           False,      // True to write
   //       responseOnWrite: False,
   //       address:         a,
   //       datain:          0 });
   //
   //    let d <- bram.portA.response.get ();
   //
   // Note the BRAM's port is a Server -- the same Put/Get pair as problem 20.

   method Action rfWrite (Bit #(4) a, Bit #(8) d);
      noAction;
   endmethod

   method Bit #(8) rfRead (Bit #(4) a);
      return 0;
   endmethod

   method Action rfBramWrite (Bit #(8) a, Bit #(8) d);
      noAction;
   endmethod

   method Action bramReadReq (Bit #(8) a);
      noAction;
   endmethod

   method ActionValue #(Bit #(8)) bramReadResp ();
      return 0;
   endmethod

endmodule

endpackage
