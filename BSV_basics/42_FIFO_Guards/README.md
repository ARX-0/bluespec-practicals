# 42 — Guards You Did Not Write

**Concept** implicit conditions: a rule inherits the readiness of everything it
touches.

## The rule

`f.first` and `f.deq` are only meaningful when the FIFO is non-empty, so
**they carry that condition with them**. A rule that calls either one silently
acquires `f.notEmpty` as part of its own guard:

```bsv
rule drain;
   acc <= acc + f.first;
   f.deq;
endrule
```

That rule cannot fire on an empty FIFO. Not because it checks — because `bsc`
added the check for you, from the method's own declaration. The same happens with
`f.enq` and `notFull`: a rule that enqueues stops firing when the queue is full.

This is called an **implicit condition**, and it is the thing that makes BSV
designs compose. Connect two modules and the backpressure is already correct: the
producer stalls when the consumer is not ready, with no `ready`/`valid` handshake
written by anyone. You are not being saved typing — you are being saved the class
of bug where the handshake is written *almost* right.

Writing `rule drain (f.notEmpty);` is not wrong, just redundant. What *is* wrong
is assuming you must, and then getting the condition subtly different from the
one the method actually needs.

## Your job

| method | does |
|---|---|
| `push(x)` | already written — enqueues `x` |
| `total()` | already written — returns the accumulator |

Write the one rule that drains the FIFO into `acc`, with no condition of its own.

## How you know it worked

The checker pushes a few values, then **stops pushing and waits**. If your rule
had no implicit condition it would keep adding `f.first` from an empty queue and
the total would run away. It should instead sit still at the right answer.

## vs Verilog

`if (!fifo_empty) begin acc <= acc + fifo_dout; fifo_rd <= 1'b1; end` — written by
hand at every consumer, and the design breaks quietly when someone reads `fifo_dout`
without checking, or asserts `fifo_rd` a cycle early. The condition here comes from
the FIFO's own interface, so it cannot be forgotten or mistyped.

## When this passes

You have finished the ladder. Go back to `BSVbits/` and start at 01 — you have now
met every construct in problems 01 through 07 of it, and problem 25 here was its
problem 04.

## Run it

```
Basics
```
