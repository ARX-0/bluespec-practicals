// ============================================================================
// 18 -- Get, Put and mkConnection
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interfaces.
//
// Every module you have written so far invented its own method names. Get
// and Put are the STANDARD names, and standard names are what let two
// modules be plugged together by a library function instead of by hand.
// ============================================================================

package Top;

import FIFOF       :: *;
import GetPut      :: *;
import Connectable :: *;

// A stage: values go in one side, come out the other.
interface Stage_IFC #(type a, type b);
   interface Put #(a) inp;
   interface Get #(b) outp;
endinterface

// ---------------------------------------------------------------------------
// TODO 1: a stage that adds 1.       in: Bit#(8)   out: Bit#(8)
// ---------------------------------------------------------------------------
module mkAddOne (Stage_IFC #(Bit #(8), Bit #(8)));

   // TODO: your code here.
   //
   // A FIFOF has toPut/toGet adapters, so a stage is usually two FIFOs and
   // a rule:
   //
   //    FIFOF #(Bit #(8)) inQ  <- mkFIFOF;
   //    FIFOF #(Bit #(8)) outQ <- mkFIFOF;
   //    rule go; ... endrule
   //    interface inp  = toPut (inQ);
   //    interface outp = toGet (outQ);

   interface Put inp;
      method Action put (Bit #(8) x);
         noAction;
      endmethod
   endinterface

   interface Get outp;
      method ActionValue #(Bit #(8)) get ();
         return 0;
      endmethod
   endinterface

endmodule

// ---------------------------------------------------------------------------
// TODO 2: a stage that multiplies by 3, widening.
//                                     in: Bit#(8)   out: Bit#(16)
// ---------------------------------------------------------------------------
module mkTimesThree (Stage_IFC #(Bit #(8), Bit #(16)));

   // TODO: your code here.

   interface Put inp;
      method Action put (Bit #(8) x);
         noAction;
      endmethod
   endinterface

   interface Get outp;
      method ActionValue #(Bit #(16)) get ();
         return 0;
      endmethod
   endinterface

endmodule

// ---------------------------------------------------------------------------
// The top. Overall transform:  (x + 1) * 3
// Do not change this interface.
// ---------------------------------------------------------------------------

interface Chain_IFC;
   interface Put #(Bit #(8))  request;
   interface Get #(Bit #(16)) response;
endinterface

(* synthesize *)
module mkTop (Chain_IFC);

   // TODO 3: instantiate both stages, connect the first's output to the
   // second's input with mkConnection, and expose the outer ends.
   //
   //    mkConnection (a.outp, b.inp);
   //
   // That one line replaces the rule you would otherwise write to move
   // data between them -- and it is the SAME line whatever the two modules
   // are, as long as they speak Get and Put.

   interface Put request;
      method Action put (Bit #(8) x);
         noAction;
      endmethod
   endinterface

   interface Get response;
      method ActionValue #(Bit #(16)) get ();
         return 0;
      endmethod
   endinterface

endmodule

endpackage
