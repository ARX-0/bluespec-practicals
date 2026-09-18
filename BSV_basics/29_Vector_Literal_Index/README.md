# 29 — Vector

**Concept** `Vector#(n, t)` — n copies of a type, with the count in the type.

## The rule

```bsv
import Vector      :: *;
import BuildVector :: *;      // only for the `vec` shorthand
```

`Vector#(4, Bit#(8))` is four `Bit#(8)`s. The **4 is part of the type**, so a
4-vector never fits where a 5-vector is expected, and no loop can run off the end.

| written | is |
|---|---|
| `vec (a, b, c, d)` | a 4-element vector |
| `v[2]` | element 2 — a constant index |
| `v[i]` | element `i` — a run-time index, i.e. a multiplexer |

Indexing with a run-time value is allowed and builds a mux, exactly as it would
in Verilog. Indexing with a value too wide for the vector is a type error.

A `Vector` is **not** a memory. It is n separate values that all exist at once,
like `wire [7:0] v [0:3]` — every element is its own set of wires.

## Example

```bsv
Vector #(3, Bit #(4)) t = vec (4'h1, 4'h2, 4'h3);
Bit #(4) middle = t[1];
```

## Your job

| method | must return |
|---|---|
| `build(a,b,c,d)` | the vector `[a, b, c, d]` |
| `elemAt(v,idx)` | element `idx` |
| `lastElem(v)` | element 3 |

## Run it

```
Basics
```
