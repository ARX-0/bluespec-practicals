# 38 — Action Methods

**Concept** the second kind of method: one that changes state.

## The rule

BSV methods come in three kinds. You have used one; here is the second:

| kind | shape | can it change state? |
|---|---|---|
| **value** | `method Bit#(8) get ();` … `return r;` | no |
| **Action** | `method Action set (Bit#(8) x);` … `r <= x;` | yes |
| **ActionValue** | problem 39 | yes, and returns something |

```bsv
method Action set (Bit #(8) x);
   r <= x;
endmethod
```

There is no `return`. The method *is* the action.

The important part is who decides when it happens: **an `Action` method does
nothing until somebody calls it**, and the only things that can call it are a
rule or another `Action` method. It has an enable wire in the generated Verilog
(`EN_set`), driven by the caller.

`noAction` is the do-nothing `Action` — useful as a placeholder, and as the
`else` branch of an `if` that only acts sometimes.

## Your job

| method | does |
|---|---|
| `set(x)` | store `x` |
| `get()` | return what is stored |
| `add(x)` | add `x` to what is stored |

## What to expect when it runs

A write lands **next** cycle. In the checker, `set (5)` on one cycle is followed
by `get()` returning 5 on the next — not on the same one. That is `<=`, exactly as
in problem 34.

## vs Verilog

A write port: `wr_en`, `wr_data`, and a convention about when `wr_en` may be
asserted that lives in a comment or a spec. `EN_set` is generated, and problem 42
shows the module driving it *back* — refusing the call when it is not ready.

## Run it

```
Basics
```
