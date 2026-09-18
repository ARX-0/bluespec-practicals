# 20 — case over an Enum

**Concept** an exhaustive `case`, and why you should leave out `default`.

## The rule

A `case` over an enum lists the values by name:

```bsv
case (state)
   Idle: return 0;
   Busy: return 1;
   Done: return 2;
endcase
```

`State` has exactly three values and all three are listed, so the `case` is
**complete** and needs no `default` — the compiler can see that.

That is worth insisting on. Suppose someone later adds `Failed` to the enum:

- with `default`, `Failed` silently takes the `default` arm and the bug ships;
- without it, `bsc` reports an incomplete `case` **at this line** — the exact
  place that needs a decision.

So: on an enum, cover every value and omit `default`. Use `default` only when you
genuinely mean "all the remaining ones" (problem 16).

## Your job

The type is already in `Top.bsv`:

```bsv
typedef enum { OpAdd, OpSub, OpAnd, OpOr }
   Opcode deriving (Bits, Eq, FShow);
```

| method | must return |
|---|---|
| `execute(op,x,y)` | `x+y`, `x-y`, `x&y`, `x\|y` for the four opcodes |

Four arms, no `default`.

## vs Verilog

```verilog
case (op)
   2'b00: y = x1 + x2;
   ...
endcase
```

with the opcode encoding spelled out as a number in every arm, and a `default:`
you must remember to add or a latch appears. The names here are the type's, and
`fshow(op)` prints `OpSub` in a waveform rather than `2'b01`.

## Run it

```
Basics
```
