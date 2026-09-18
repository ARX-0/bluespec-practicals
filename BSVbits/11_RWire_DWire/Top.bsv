// ============================================================================
// 11 -- RWires and DWires: rule-to-rule communication with no state
//
// >>> THIS IS THE FILE YOU EDIT. <<<   Do not change the interface.
//
// A register passes a value from one cycle to the NEXT. Sometimes you need
// one rule to hand a value to another rule within the SAME cycle, without
// storing it. That is a wire.
// ============================================================================

package Top;

interface Wire_IFC;
   // A free-running counter, from 0, +1 every cycle.
   method Bit #(8) tick;

   // How many pulses have been seen so far. A pulse happens on every cycle
   // where the CURRENT tick has its low two bits zero (0, 4, 8, ...).
   method Bit #(8) hits;

   // The tick value carried by the most recent pulse. Starts at 0.
   // It must update in the SAME cycle as the pulse, not one cycle later.
   method Bit #(8) last;
endinterface

(* synthesize *)
module mkTop (Wire_IFC);

   // TODO: your code here.
   //
   // Structure it as three rules that talk to each other through a wire:
   //
   //    RWire #(Bit #(8)) pulse <- mkRWire;
   //
   //    rule produce (...);   pulse.wset (<value>);   endrule
   //    rule consume (...);   ... read pulse.wget ... endrule
   //    rule advance;         tick_r <= tick_r + 1;   endrule
   //
   // `pulse.wget` is a Maybe#(Bit#(8)): Valid when some rule called wset
   // this cycle, Invalid otherwise.

   method Bit #(8) tick;
      return 0;
   endmethod

   method Bit #(8) hits;
      return 0;
   endmethod

   method Bit #(8) last;
      return 0;
   endmethod

endmodule

endpackage
