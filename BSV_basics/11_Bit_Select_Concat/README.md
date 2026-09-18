# 11 — Bit Selection and Concatenation

**Concept** `a[hi:lo]`, `a[i]`, and `{x, y}`.

## The rule

These are the Verilog forms, unchanged:

| written | is |
|---|---|
| `a[7:4]` | a `Bit#(4)` — bits 7 down to 4 |
| `a[3]` | a `Bit#(1)` — one bit, still a vector |
| `{hi, lo}` | concatenation, **leftmost ends up highest** |

Two BSV-specific notes:

- The indices in `a[hi:lo]` must be **constants**. A variable index selects a
  single bit only (`a[i]`); a variable *range* needs a shift.
- `a[3]` has type `Bit#(1)`, not `Bool`. To use it as a condition, write
  `a[3] == 1` (problem 05).

## Example

```bsv
Bit #(8) x   = 8'hAB;
Bit #(4) top = x [7:4];             // 4'hA
Bit #(12) y  = {x, 4'hF};           // 12'hABF
```

## Your job

| method | must return |
|---|---|
| `high4(a)` | bits 7:4 |
| `bit3(a)` | bit 3 |
| `joinNibbles(hi,lo)` | `hi` in bits 7:4, `lo` in bits 3:0 |
| `swapHalves(a)` | bits 3:0 on top, bits 7:4 below |

## Run it

```
Basics
```
