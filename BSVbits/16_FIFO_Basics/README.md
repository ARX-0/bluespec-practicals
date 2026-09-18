# 16 — The library FIFOs

**Difficulty** ▮▮▯▯▯ · **Concepts** `mkFIFOF`, `first`/`deq`/`enq`, FIFO variants and their schedules · **Prereq** 13

---

## The Verilog you'd write

A synchronous FIFO: pointers, a wrap-around, a count, `full`/`empty`, and — if you
want enqueue and dequeue in the same cycle — careful thought about the count update
and probably a bug. Then you copy it into the next project and adjust the widths.

## The problem

Rebuild problem 13's buffer, but out of library FIFOs, and put a transform in the
middle:

| method | behaviour |
|---|---|
| `enq(x)` | accept an item. Guarded |
| `deq()` | produce items in order, transformed by `x + 1`. Guarded |
| `notFull()`, `notEmpty()` | status |

Structure it as **two FIFOs and a rule between them**. Write no flow control.

## Tutorial: the BSV you need

```bsv
import FIFOF :: *;

FIFOF #(Bit #(8)) f <- mkFIFOF;

f.enq (x);       // Action, guarded on not-full
f.first          // value method: the oldest item, guarded on not-empty
f.deq;           // Action: remove the oldest, guarded on not-empty
f.notFull        // Bool
f.notEmpty       // Bool
f.clear;         // Action
```

Note `first` and `deq` are **separate**. Reading does not remove; you do both:

```bsv
rule move;
   let x = inF.first;
   inF.deq;
   outF.enq (x + 1);
endrule
```

This rule needs `inF` non-empty **and** `outF` non-full to fire, and `bsc` works
that out from the guards. You did not write it.

**`FIFO` vs `FIFOF`.** `FIFO#(t)` has `enq`/`first`/`deq`/`clear`. `FIFOF#(t)` adds
`notFull`/`notEmpty` as readable `Bool`s. Use `FIFOF` when something needs to *ask*;
use `FIFO` when the guards alone are enough — which is most of the time.

**The variants, which differ only in what may happen in one cycle:**

| module | depth | `enq` and `deq` same cycle when… |
|---|---|---|
| `mkFIFOF` | 2 | not full and not empty — the general-purpose one |
| `mkSizedFIFOF(n)` | n | as above, at your chosen depth |
| `mkPipelineFIFO` | 1 | full — `deq` is scheduled *before* `enq`, so the slot is freed first |
| `mkBypassFIFO` | 1 | empty — `enq` is scheduled *before* `deq`, so a value can arrive and leave in the same cycle |
| `mkLFIFO` | 1 | like pipeline, one element |

`mkPipelineFIFO` costs a cycle of latency but no combinational path through the
data. `mkBypassFIFO` has zero latency but puts the producer's logic combinationally
in front of the consumer's. That trade is the whole design space of pipeline
registers, and BSV names both ends of it.

**They are all built out of CRegs** (problem 10). "`deq` before `enq`" is exactly
"`deq` uses port 0, `enq` uses port 1". Nothing new is happening.

## What changed from Verilog

- **Flow control is not code any more.** The rule above is three lines and cannot
  overflow or underflow.
- **The concurrency choice has a name.** In Verilog "can this FIFO do both in one
  cycle" is an emergent property of how you wrote the pointer logic. Here you pick a
  module, and the choice is legible in the source.
- **`first` and `deq` split usefully.** You can look at the head, decide, and only
  then remove it — which is how you write a rule that peeks at a request before
  committing to handle it.
- **Depth is a parameter, not a rewrite.**

## How you're checked

300 randomised rounds. The testbench only issues an operation when **both** modules
are ready, so the reference can have a different capacity — what must match is the
order and value of everything that comes out. It also insists that a reasonable
number of items actually flowed, so a module that accepts nothing cannot pass by
doing nothing.

## Run it

```
Run
```
