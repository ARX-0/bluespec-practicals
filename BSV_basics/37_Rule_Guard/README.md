# 37 — A Rule Guard

**Concept** a guard decides *whether the rule fires*, not what it writes.

## The rule

The condition goes in parentheses after the rule's name:

```bsv
rule bump (r < 10);
   r <= r + 1;
endrule
```

When `r < 10` is false the rule **does not fire at all**. Nothing in its body
happens: no register is written, no method is called, no FIFO moves. The rule is
simply not part of that cycle.

Compare with problem 36:

| | when the condition is false |
|---|---|
| `if` **inside** the rule | the rule fires; the other branch's value is written |
| condition **on** the rule | the rule does not fire; nothing at all happens |

Here both give a counter that stops at 10 — but for different reasons, and only
one of them scales. Once a rule's body does several things (writes two
registers, dequeues a FIFO, calls a method), a guard stops *all* of it
atomically. An `if` would need repeating around every statement, and getting one
wrong leaves the design half-updated. **That atomicity is the central idea of
BSV.**

Guards also compose: from problem 42 on, a rule that touches a full FIFO acquires
that FIFO's condition automatically, and stalls itself.

## Your job

| method | must return |
|---|---|
| `count()` | 0, 1, 2, … 10, and then 10 forever |

Note the counter *does* reach 10 here, unlike problem 36 — think about which
value of `r` makes the guard false.

## vs Verilog

`if (r < 10) r <= r + 1;` inside an `always` block is the *other* form. Verilog
has no way to say "do not run this block at all", because a `always` block has no
say in whether its clock ticks. A guard is genuinely new.

## Run it

```
Basics
```
