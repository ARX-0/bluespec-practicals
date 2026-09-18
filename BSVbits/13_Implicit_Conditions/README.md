# 13 — Implicit Conditions: the handshake you don't have to wire

**Difficulty** ▮▮▮▮▯ · **Concepts** guarded methods, `RDY` propagation, backpressure · **Prereq** 12

---

> This is the idea that makes BSV worth learning. Everything before it has a
> reasonable Verilog equivalent. This one does not.

## The Verilog you'd write

```verilog
// producer
assign fifo_wr_en = have_data && !fifo_full;      // <-- you wrote !fifo_full
// consumer
assign fifo_rd_en = want_data && !fifo_empty;     // <-- and !fifo_empty
```

The buffer exports `full` and `empty`; **every caller** is responsible for checking
them. Miss one — in a corner case, in a rarely-taken branch, in code someone adds
next year — and you overflow the buffer and lose data, silently, in a way that
shows up as a corrupted packet three modules downstream.

That is the bug BSV makes structurally impossible.

## The problem

Build a **4-deep circular buffer** by hand:

| method | behaviour |
|---|---|
| `enq(x)` | add an item. **Guarded**: only callable when not full |
| `deq()` | remove and return the oldest item, FIFO order. **Guarded**: only callable when not empty |
| `notFull()`, `notEmpty()`, `depth()` | status, always readable |

You will use the library `mkFIFO` from problem 16 on. Building one yourself once is
how the library stops being magic.

## Tutorial: the BSV you need

**A guarded method carries a condition after its argument list:**

```bsv
method Action enq (Bit #(8) x) if (cnt < 4);
   ...
endmethod
```

That is an **implicit condition**. It is *not* an `if` around the body — read it as
"this method does not exist on cycles when the buffer is full."

**What `bsc` does with it.** The condition becomes the method's `RDY_enq` output,
and then — this is the important part — **any rule that calls `enq` gets `RDY_enq`
ANDed into its own firing condition, automatically.**

```bsv
rule produce;
   buf.enq (x);       // this rule cannot fire when buf is full
endrule
```

You did not write `if (!full)`. You cannot forget to write it. A caller that would
overflow the buffer simply does not fire that cycle, and — because a rule is atomic
— nothing else in that rule happens either. The producer stalls, in one piece.

**This composes to arbitrary depth.** If `produce` also calls `out.enq`, the rule
needs *both* to be ready. Chain modules together and backpressure propagates the
whole way back with no flow-control signals written anywhere. That is what people
mean when they say BSV designs "just work" when you compose them.

**The circular buffer itself** is the ordinary trick: a `head` index, a `tail`
index, and a count. Make the indices `Bit#(2)` and they wrap 3 → 0 on their own.

```bsv
Vector #(4, Reg #(Bit #(8))) data <- replicateM (mkReg (0));
Reg #(Bit #(2)) head <- mkReg (0);
Reg #(Bit #(2)) tail <- mkReg (0);
Reg #(Bit #(3)) cnt  <- mkReg (0);    // 3 bits: must hold 4
```

`data[tail] <= x` with a dynamic index works and builds the write decoder for you.

**Why `cnt` is `Bit#(3)`.** It ranges 0..4, which does not fit in 2 bits. A
classic off-by-one; here it is a width error at compile time.

## What changed from Verilog

- **The check moved from the caller to the callee, once.** `enq` states its own
  precondition. Every present and future caller inherits it. In Verilog the
  precondition is documented at the callee and enforced at every caller — the
  worst possible split.
- **"Not ready" stalls the caller instead of corrupting the callee.** A rule that
  cannot fire does not partially fire. Compare a Verilog `wr_en` asserted into a
  full FIFO: the write happens, and it is wrong.
- **Backpressure is free and transitive.** No `ready`/`valid` wiring, no
  almost-full thresholds, no skid buffers to hand-build. Problem 17 shows this
  properly.
- **The cost: your design can deadlock.** If a guard never becomes true, the caller
  waits forever. That is a real failure mode and BSV does not prevent it — which is
  why the checker has a watchdog. Get a guard wrong here and you will see it.

## How you're checked

250 randomised enq/deq rounds. The testbench only issues a call when the
*reference* says it is legal, and compares returned values plus all three status
methods every round.

Two ways to fail, both informative: wrong guards make the modules diverge on
`notFull`/`notEmpty`; a guard that is too strict means your `enq` or `deq` is never
ready, the testbench rule blocks, and the watchdog reports a stall after 5000
cycles rather than hanging forever.

## Run it

```
Run
```
