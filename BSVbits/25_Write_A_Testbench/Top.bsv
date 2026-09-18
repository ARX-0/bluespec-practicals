// ============================================================================
// 25 -- Write the testbench
//
// >>> THIS IS THE FILE YOU EDIT. <<<
//
// Every problem so far handed you a checker. This one does not. You write
// the tester, and the tester itself is what gets graded:
//
//   * it is run against ONE CORRECT module, which it must ACCEPT
//   * it is run against THREE BROKEN modules, each of which it must REJECT
//
// A lazy test passes the correct module and passes the broken ones too.
// That is the whole lesson.
// ============================================================================

package Top;

import StmtFSM :: *;

// The thing under test: absolute difference.
//   absdiff (a, b) == |a - b|,  treating a and b as UNSIGNED 0..255.
//   absdiff (3, 10) == 7.   absdiff (10, 3) == 7.   absdiff (5, 5) == 0.
interface AbsDiff_IFC;
   method Bit #(8) absdiff (Bit #(8) a, Bit #(8) b);
endinterface

// What your tester must report.
interface Tester_IFC;
   method Bool done ();     // finished testing
   method Bool passed ();   // the verdict; only read once done is True
endinterface

// ---------------------------------------------------------------------------
// TODO: write the tester.
//
// It is handed a module and must decide whether that module is correct.
// Set `passed` False if you ever see a wrong answer.
//
// Two things to get right:
//
//  1. BE EXHAUSTIVE. There are only 256 x 256 = 65536 input pairs. That is
//     nothing for a simulator. One of the three broken modules is wrong for
//     exactly ONE pair out of 65536 -- random sampling will not find it, and
//     it is meant not to.
//
//  2. DO NOT use mkAutoFSM here. mkAutoFSM calls $finish when its sequence
//     completes, which would kill the whole simulation -- including the
//     other three testers running alongside yours. Use mkFSM and start it
//     from a rule, or just write plain rules.
//
// A sketch, if you want the StmtFSM route:
//
//    Reg #(Bit #(9)) a <- mkReg (0);        -- 9 bits, so it can reach 256
//    Reg #(Bit #(9)) b <- mkReg (0);
//    Reg #(Bool) ok   <- mkReg (True);
//    Reg #(Bool) fin  <- mkReg (False);
//    Reg #(Bool) started <- mkReg (False);
//
//    Stmt prog = seq ... endseq;
//    FSM fsm <- mkFSM (prog);
//    rule kick (! started); fsm.start; started <= True; endrule
// ---------------------------------------------------------------------------

module mkTester #(AbsDiff_IFC dut) (Tester_IFC);

   // TODO: your code here.
   //
   // The stub below claims every module is correct without testing anything.
   // It will accept the good module AND all three broken ones.

   method Bool done ()   = True;
   method Bool passed () = True;

endmodule

endpackage
