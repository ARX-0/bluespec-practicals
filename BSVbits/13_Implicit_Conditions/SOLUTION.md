# Solution — 13

Only if dire.

---

```bsv
   Vector #(4, Reg #(Bit #(8))) data <- replicateM (mkReg (0));
   Reg #(Bit #(2))              head <- mkReg (0);
   Reg #(Bit #(2))              tail <- mkReg (0);
   Reg #(Bit #(3))              cnt  <- mkReg (0);

   method Action enq (Bit #(8) x) if (cnt < 4);
      data[tail] <= x;
      tail <= tail + 1;
      cnt  <= cnt + 1;
   endmethod

   method ActionValue #(Bit #(8)) deq () if (cnt > 0);
      head <= head + 1;
      cnt  <= cnt - 1;
      return data[head];
   endmethod

   method Bool     notFull ()  = (cnt < 4);
   method Bool     notEmpty () = (cnt > 0);
   method Bit #(3) depth ()    = cnt;
```

## Why it is written this way

**The guard is the interface, not an implementation detail.** `if (cnt < 4)` on
`enq` becomes `RDY_enq` in the generated Verilog, and `bsc` ANDs it into the
condition of every rule that calls `enq`. The overflow check exists once, at the
buffer, and is enforced at every call site the compiler can see — including ones
written years later by someone who never read this file.

Contrast the Verilog idiom, where the buffer exports `full` and each caller writes
`&& !full`. Same logic, but the enforcement is distributed and voluntary.

**`cnt` is `Bit#(3)`, not `Bit#(2)`.** It holds 0 through 4 — five values. In
Verilog `reg [1:0] cnt` with a count of 4 wraps to 0 and the buffer reports itself
empty when it is full, which is a genuinely nasty bug to find. Here the widths do
not typecheck and you fix it before running anything.

**`head` and `tail` *are* `Bit#(2)`, deliberately.** They index four slots and must
wrap 3 → 0, which unsigned overflow does for free. Using the natural width as the
wrap mechanism is idiomatic; it is the same trick as the Verilog version, just
checked.

**`return data[head]` after `head <= head + 1`.** Same non-blocking read as problem
12 — the `return` sees the old `head`. Ordering inside the method body is
irrelevant.

**`enq` and `deq` conflict here.** Both write `cnt`, so `bsc` will not let one rule
call both in the same cycle, and this buffer therefore cannot sustain simultaneous
enqueue and dequeue. That is a real limitation and it is why `mkFIFO` is built with
CRegs rather than plain registers — you now have everything you need to see why
(problem 10 gave you the mechanism, problem 16 shows the library making the choice).

**Why the guards and the status methods have identical expressions.** The guard is
what the *compiler* uses to block callers; `notFull` is what a *human* or a
testbench uses to decide what to do. Both are needed and they should agree. In BSV
you would often skip `notFull` entirely and rely on the guard — the library
`mkFIFOF` provides both for exactly this reason.

## What to take forward

**The one-sentence version of BSV's value proposition:** a method that must not be
called right now says so, and the compiler makes every caller respect it.

This is where the "correct by construction" claim actually comes from. Not from
types, not from rules being atomic, but from readiness propagating from callee to
caller automatically and transitively. Once every module in a design states its own
preconditions, composing them cannot produce a protocol violation.

The price is deadlock: a design where two modules each wait for the other compiles
fine and hangs. You have now seen the watchdog that catches it. When a BSV design
stops making progress, the question is always "which guard is never true, and who
is waiting on it".
