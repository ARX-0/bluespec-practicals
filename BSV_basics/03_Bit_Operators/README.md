# 03 — Bitwise Operators

**Concept** `&` `|` `^` `~` on `Bit#(n)`.

## The rule

On `Bit#(n)` the bitwise operators are the ones you already know, and they work
lane by lane across all `n` bits. Both operands must be the **same width** —
BSV will not silently extend one to match the other.

| operator | does |
|---|---|
| `a & b` | bitwise AND |
| `a \| b` | bitwise OR |
| `a ^ b` | bitwise XOR |
| `~a` | bitwise NOT |

## Example

```bsv
method Bit #(4) nandOp (Bit #(4) a, Bit #(4) b);
   return ~(a & b);
endmethod
```

## Your job

| method | must return |
|---|---|
| `andOp(a,b)` | `a & b` |
| `orOp(a,b)` | `a \| b` |
| `xorOp(a,b)` | `a ^ b` |
| `notOp(a)` | `~a` |

## Run it

```
Basics
```
