# 39 — ActionValue Methods

**Concept** the third method kind: acts *and* returns a value.

## The rule

```bsv
method ActionValue #(Bit #(8)) take ();
   next <= next + 1;
   return next;
endmethod
```

It has a body full of actions **and** a `return`. Use it whenever getting the
value is inseparable from the side effect — taking a ticket, popping a queue,
consuming an item.

Calling one uses `<-`, not `=`:

```bsv
rule r;
   let t <- dut.take;      // performs the action, binds the result
endrule
```

The same `<-` as `mkReg` in problem 33, and for the same reason: both are "do
something in the hardware and give me back a handle on the result", not "name an
expression". Writing `let t = dut.take;` is a type error, and a helpful one — it
is the compiler telling you this call *does* something.

The three kinds, complete:

| kind | example | acts | returns |
|---|---|---|---|
| value | `method Bit#(8) peek ();` | no | yes |
| Action | `method Action set (…);` | yes | no |
| ActionValue | `method ActionValue#(Bit#(8)) take ();` | yes | yes |

## Your job

| method | does |
|---|---|
| `take()` | returns the current ticket number and advances it by one |
| `peek()` | returns the next ticket number, changing nothing |

`take` returns the value the counter had **before** the call — the same `<=`
timing as everywhere else.

## Run it

```
Basics
```
