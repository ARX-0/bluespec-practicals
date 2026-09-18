# 17 — Functions

**Concept** naming a piece of combinational logic once and reusing it.

## The rule

A `function` is a named expression. It lives at package level (outside any
module) or inside a module, and it is **not** hardware by itself — each *call*
elaborates into its own copy of the logic.

```bsv
function Bit #(8) doubleIt (Bit #(8) x);
   return x << 1;
endfunction
```

Call it like any other function: `doubleIt (a)`. Two calls means two shifters;
there is no sharing and no calling convention, because there is no call at
runtime. The function has been inlined before any gates exist.

Short bodies can drop `return`/`endfunction` entirely:

```bsv
function Bit #(8) doubleIt (Bit #(8) x) = x << 1;
```

## Your job

Write **one** function at package level, then use it in both methods:

| method | must return |
|---|---|
| `twiceSum(a,b)` | `2*a + 2*b` |
| `quad(a)` | `4*a` |

All arithmetic is 8-bit and wraps — `quad(100)` is 144, not 400.

## vs Verilog

Verilog's `function` is the same idea. What differs is that BSV functions are
ordinary values: later on you will pass one to `map` (problem 31) and get a whole
row of copies built for you.

## Run it

```
Basics
```
