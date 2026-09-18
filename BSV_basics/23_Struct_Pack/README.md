# 23 — pack on a Struct

**Concept** a struct's bit layout, and `pack` producing it in one call.

## The rule

`deriving (Bits)` gives a struct a layout, and the rule is short:

> **Declaration order, first field in the highest bits.**

```bsv
typedef struct {
   Bit #(4) tag;         // [15:12]
   Bit #(4) len;         // [11:8]
   Bit #(8) payload;     // [7:0]
} Header deriving (Bits, Eq, FShow);
```

Total width is the sum of the fields: 16. `pack (h)` gives you those 16 bits:

```bsv
Bit #(16) raw = pack (h);
```

You never write the indices, and you never write the total. Widen `len` to 6 bits
and the struct becomes 18 bits wide — every `pack` in the design follows, and
nothing else changes. **This is the single biggest day-to-day difference from
Verilog.**

## Your job

| method | must return |
|---|---|
| `toBits(h)` | all 16 bits of `h` |
| `topByte(h)` | the top 8 bits — use `truncateLSB` (problem 10), not `[15:8]` |

`topByte` is `{tag, len}` — but write it without saying so, so it keeps working
if the fields change width.

## vs Verilog

```verilog
wire [15:0] raw = {tag, len, payload};
```

Correct, and it must be repeated and kept in step at every site that builds or
reads a header. `pack` is the same wires, with the layout stated once in the type.

## Run it

```
Basics
```
