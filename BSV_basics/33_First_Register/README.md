# 33 — Your First Register

**Concept** `mkReg`, the `<-` that instantiates it, and reading it.

## The rule

A register is a **module you instantiate**, not a variable you declare:

```bsv
Reg #(Bit #(8)) r <- mkReg (42);
```

Read left to right: `r` is a `Reg#(Bit#(8))`, produced by instantiating `mkReg`
with reset value 42. The `<-` is what makes it an instantiation — `=` would be
trying to *name a value*, and `bsc` will say so.

| written | means |
|---|---|
| `r` | the value it holds **now** — read it like any other value |
| `r <= x` | schedule `x` to be its value **next cycle** |

`42` is the **reset value**. There is no reset block anywhere in this file, and
you will never write one: every register in BSV comes up holding the value you
gave `mkReg`, and there is no `x` state to propagate.

`mkRegU` exists for the rare case where you truly do not care — it produces a
register with *no* reset, which saves the reset wiring.

## Your job

Instantiate a `Reg#(Bit#(8))` starting at 42, and return its contents from
`get()`.

| method | must return |
|---|---|
| `get()` | 42 — the register is never written, so it stays at its reset value |

## vs Verilog

```verilog
reg [7:0] r;
always @(posedge clk)
   if (rst) r <= 8'd42;
```

The clock and the reset are in every one of those blocks, by hand, forever. In
BSV they are implicit: `mkReg` is given the clock and reset of its parent module
and you never mention either.

## Run it

```
Basics
```
