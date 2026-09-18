# 04 — Literals and Widths

**Concept** how to write a constant, and the two width-inferring shorthands.

## The rule

A sized literal is `<width>'<base><digits>`, exactly as in Verilog:

| written | means |
|---|---|
| `8'hF0` | 8 bits, hex F0 |
| `8'd42` | 8 bits, decimal 42 |
| `8'b0000_1111` | 8 bits, binary (underscores are just spacing) |
| `42` | *unsized* — BSV infers the width from where you use it |
| `'1` | all bits **one**, however wide the context needs |
| `0` | all bits zero |

`'1` is the one that has no Verilog equivalent worth remembering: it means "the
all-ones value of whatever type this is", so it never needs updating when the
width changes.

## Example

```bsv
Bit #(12) mask = '1;      // 12 ones -- no need to write 12'hFFF
Bit #(12) none = 0;       // 12 zeros
```

## Your job

| method | must return |
|---|---|
| `hexLit()` | `8'hF0` |
| `decLit()` | 42 |
| `binLit()` | `8'b0000_1111` |
| `allOnes()` | all eight bits set — use `'1` |
| `zeros()` | all eight bits clear |

## Run it

```
Basics
```
