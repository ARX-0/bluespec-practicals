# Solution — 21

Only if dire.

---

```bsv
   Reg #(Bit #(8))    n_r  <- mkReg (0);
   Reg #(Bit #(8))    i    <- mkReg (0);
   Reg #(Bit #(16))   acc  <- mkReg (0);
   FIFOF #(Bit #(16)) outQ <- mkFIFOF;

   Stmt prog =
      seq
         action
            acc <= 0;
            i   <= 0;
         endaction
         while (i < n_r) seq
            action
               acc <= acc + zeroExtend (i);
               i   <= i + 1;
            endaction
         endseq
         outQ.enq (acc);
      endseq;

   FSM fsm <- mkFSM (prog);

   method Action start (Bit #(8) n) if (fsm.done);
      n_r <= n;
      fsm.start;
   endmethod

   method Bool busy () = ! fsm.done;

   method ActionValue #(Bit #(16)) result ();
      outQ.deq;
      return outQ.first;
   endmethod
```

## Why it is written this way

**`outQ.enq (acc)` is a separate statement in the `seq`, and that matters.** Each
`action` is one cycle, and `<=` lands at the end of it. When the loop's last iteration
runs, `acc <= acc + i` is scheduled but `acc` still reads as the old value for the
rest of that cycle. Enqueueing inside the loop body would therefore publish a sum one
term short — and only on the final iteration, so small n would look fine.

Putting the enqueue in the next `seq` step gives it a fresh cycle in which `acc` has
settled. This is the same "non-blocking write has not landed yet" trap as problems 12
and 20, and it is the one that recurs most.

**`while (i < n_r)` handles n = 0 for free.** The condition is tested before the first
iteration, so the loop body never runs, `acc` stays 0, and 0 is the right answer. A
`repeat`/do-while shape would have to special-case it. The testbench forces n = 0 and
n = 1 on the first two rounds for exactly this reason.

**`mkFSM`, not `mkAutoFSM`.** `mkAutoFSM` starts itself and calls `$finish` on
completion — appropriate for a top-level testbench (all the checkers in this course
use it) and fatal anywhere else. You want an FSM you can start repeatedly.

**`start` guarded on `fsm.done`.** Without it, calling `start` mid-computation would
reset `i` and `acc` underneath the running FSM and quietly corrupt the result. The
guard makes it a scheduling fact instead: the caller blocks until the unit is free.
Same idle-guard pattern as problem 20.

**`n_r <= n` and `fsm.start` in the same cycle is safe.** `fsm.start` takes effect
such that the first `action` of `prog` runs the following cycle, by which time `n_r`
holds the new value.

**Accumulator width.** `acc` must be 16 bits: the largest sum is 254·255/2 = 32385.
An 8-bit accumulator wraps and the checker catches it immediately.

## What to take forward

**Use `StmtFSM` when the control flow is genuinely a fixed sequence** — an
initialisation routine, a calibration sweep, a test sequence, a multi-step transaction
you always perform the same way. It is dramatically clearer than a hand-rolled state
enum and there is no runtime cost; it compiles to the same state machine you would
have written.

**Do not use it when the design must react to things arriving from outside.** `seq`
is an ordering commitment. A module that has to handle whichever of three inputs
turns up first, or stall elastically, wants guarded rules — the ordering there comes
from the guards and the data, not from the source text.

Problem 22 writes this same kind of machine by hand, and shows what you give up and
what you get back.
