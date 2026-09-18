# 08 — zeroExtend

**Concept** widths never change by themselves; `zeroExtend` is how you widen.

## The rule

`Bit#(4)` and `Bit#(8)` are **different types**. Nothing in BSV will pad one to
match the other — an operator with mismatched widths is a compile error.

```
zeroExtend (x)   // wider, new high bits are 0
```

You do not write the target width. `zeroExtend` produces whatever width the
context needs, and `bsc` errors if that is *narrower* than the input.

## Example

```bsv
Bit #(4)  n   = 4'hB;
Bit #(12) wide = zeroExtend (n);       // 12'h00B
Bit #(8)  sum  = a8 + zeroExtend (n);  // widths now match
```

## Your job

| method | must return |
|---|---|
| `widen8(a)` | `a` in the low 4 bits, zeros above |
| `widen16(a)` | `a` in the low 8 bits, zeros above |
| `addNibble(a,n)` | `a + n`, with `n` zero-extended to 8 bits first |

## vs Verilog

Verilog widens silently at every assignment and every operator, which is
convenient right up to the day a 33-bit sum lands in a 32-bit wire. Here that is
a compile error at the line where it happens.

## Run it

```
Basics
```
