# 41 — A FIFO

**Concept** the library queue, and its four methods.

## The rule

```bsv
import FIFOF :: *;

FIFOF #(Bit #(8)) f <- mkSizedFIFOF (4);
```

A `FIFOF#(t)` is an ordinary module you instantiate, like `mkReg`. Its methods:

| method | kind | does |
|---|---|---|
| `f.enq (x)` | Action | add `x` at the back |
| `f.first` | value | the item at the front — **does not remove it** |
| `f.deq` | Action | remove the front item — **does not return it** |
| `f.notEmpty` | value | is there anything to read? |
| `f.notFull` | value | is there room to write? |

Reading and removing are **two separate methods**. To consume an item you use
both, in the same rule:

```bsv
rule consume;
   let x = f.first;
   f.deq;
   ...
endrule
```

That split is deliberate: it lets a rule look at the front item and decide whether
to take it. (`FIFO` — no F — is the same queue without `notEmpty`/`notFull`
exposed. `FIFOF` is the one to reach for while learning.)

## Your job

| method | does |
|---|---|
| `push(x)` | enqueue `x` |
| `pop()` | return the oldest item and remove it |
| `empty()` | `True` when the queue holds nothing |
| `full()` | `True` when the queue holds four items |

`empty` and `full` are the opposites of what the FIFO gives you — one `!` each.

## Run it

```
Basics
```
