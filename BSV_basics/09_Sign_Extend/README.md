# 09 — signExtend

**Concept** the other way to widen, and why the choice is yours to make.

## The rule

```
zeroExtend (x)   // new high bits are 0
signExtend (x)   // new high bits are copies of x's top bit
```

Both take the target width from context, exactly like problem 08. The bits going
in are identical; only the padding differs. `4'b1011` becomes `8'b0000_1011`
under `zeroExtend` and `8'b1111_1011` under `signExtend`.

Nothing about `Bit#(4)` says which one is correct — `Bit#(n)` has no signedness.
**You** decide, at the call site, by picking the function.

## Example

```bsv
Bit #(4) n = 4'b1011;            // 11 unsigned, -5 as a signed nibble
Bit #(8) u = zeroExtend (n);     // 8'h0B  = 11
Bit #(8) s = signExtend (n);     // 8'hFB  = -5
```

## Your job

| method | must return |
|---|---|
| `sext(a)` | `a` sign-extended to 8 bits |
| `zext(a)` | `a` zero-extended to 8 bits |
| `sextI(a)` | `a` widened to `Int#(16)` |

## vs Verilog

`{{4{a[3]}}, a}` — the replication idiom you write from memory and occasionally
get wrong by one. Here it is a named function and the width comes from the
destination.

## Run it

```
Basics
```
