# 17 — Producer / Consumer: backpressure you did not write

**Difficulty** ▮▮▮▯▯ · **Concepts** rate mismatch, automatic stalling, transitive backpressure · **Prereq** 16

---

## The Verilog you'd write

```verilog
assign prod_en = !fifo_full;                  // producer throttles itself
assign cons_en = (phase == 0) && !fifo_empty; // consumer checks too
```

Two `en` signals, each carrying a hand-written flow-control term. Now add a third
stage and the terms multiply; add an almost-full threshold for timing and they
multiply again. This is where most RTL bugs live.

## The problem

A producer that can run **every cycle**, a consumer that can only run **every 4th
cycle**, and a FIFO between them.

- producer: enqueues 0, 1, 2, 3, … one per cycle
- consumer: every 4th cycle, takes one value `x` and produces `x * x`
- `result()` hands out the consumer's output in order

The sequence out must be **0, 1, 4, 9, 16, 25, …** with nothing dropped and nothing
repeated. Write **no flow control**.

## Tutorial: the BSV you need

Nothing new. That is the point of the problem.

```bsv
rule produce;
   q.enq (nextV);
   nextV <= nextV + 1;
endrule
```

`q.enq` is guarded on not-full. So when the FIFO fills — which it will, within a few
cycles, because the producer is 4× faster — `RDY_enq` goes low, `produce` **cannot
fire**, and `nextV` does not advance either.

That last clause is the one to notice. A rule is atomic: when `produce` cannot fire,
*neither* of its two actions happens. The counter and the enqueue stay in step
automatically. Had you written this with a separate always-firing counter and a
conditional enqueue, they would drift apart the first time the FIFO filled, and you
would silently skip values.

**The consumer throttles itself with a guard:**

```bsv
rule consume (phase == 0);
   let x = q.first;
   q.deq;
   outQ.enq (zeroExtend (x) * zeroExtend (x));
endrule
```

Two conditions are in play — your `phase == 0`, and `q`'s not-empty — and `bsc`
combines them. You wrote one.

## What changed from Verilog

- **The producer stalls correctly without being told to.** No `!full` term, no
  enable, no throttle. The FIFO's guard reaches back into the producer's rule.
- **Atomicity keeps the state consistent under stalling.** This is the part that is
  genuinely hard to get right by hand: when a stage stalls, *everything* in that
  stage stalls together. In Verilog you must remember to gate every register in the
  stage with the same enable, and forgetting one is the classic pipeline bug.
- **Backpressure is transitive.** Put another stage upstream and it stalls too, with
  no new code. Chains of arbitrary depth compose.
- **Rate mismatch is not a special case.** A 4:1 mismatch and a 1:1 match are the
  same code. In Verilog the fast-producer case demands a throttle that the matched
  case does not, so the two look different and the throttle gets forgotten.

## How you're checked

The testbench pulls 120 results and compares each against a **pure model** that
knows only that the nth result must be n². The model has no FIFOs and no timing —
your pipeline may schedule itself however it likes, but it may not drop, duplicate
or reorder.

A design that loses items under backpressure fails on a *value*, not by going
missing: result 30 comes out as 961 when it should be 900. A design that
deadlocks trips the watchdog.

## Run it

```
Run
```
