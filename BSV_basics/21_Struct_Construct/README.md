# 21 — Building a Struct

**Concept** `typedef struct`, and constructing a value of one.

## The rule

A struct groups several values under one name:

```bsv
typedef struct {
   Bit #(8) lo;
   Bit #(4) hi;
} Word deriving (Bits, Eq, FShow);
```

The same three `deriving` clauses as an enum, and they mean the same things —
`Bits` lets it travel on wires, `Eq` gives `==` across every field at once,
`FShow` prints it field by field.

You build one **by naming the fields**:

```bsv
Word w = Word { lo: 8'hFF, hi: 4'h3 };
```

There is no positional form. The names are required, so there is no field order
to get subtly wrong — and adding a field later breaks every construction site
with a clear error rather than shifting values silently.

## Your job

The type is already declared:

```bsv
typedef struct {
   Bit #(8) x;
   Bit #(8) y;
} Point deriving (Bits, Eq, FShow);
```

| method | must return |
|---|---|
| `make(a,b)` | the point with `x = a`, `y = b` |
| `origin()` | `x = 0`, `y = 0` |
| `diagonal(v)` | `x = v`, `y = v` |

## vs Verilog

The nearest Verilog is a `localparam` for each field's bit range plus a comment
describing the layout. Here the layout is the declaration, and it is checked.

## Run it

```
Basics
```
