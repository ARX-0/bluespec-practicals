# 14 — if / else inside a Method

**Concept** multi-way conditions written as statements instead of nested `? :`.

## The rule

`if` / `else if` / `else` work inside a method body, and each branch can `return`:

```bsv
method Bit #(2) f (Bit #(8) x);
   if      (x < 10)  return 0;
   else if (x < 100) return 1;
   else              return 2;
endmethod
```

This is still **combinational logic** — a priority multiplexer, evaluated fresh
every time the method is called. Nothing is sequenced and nothing is stored.

The conditions must be `Bool`s, and every path must reach a `return`. Miss a case
and `bsc` complains at compile time — there is no latch to accidentally infer.

Multiple statements in a branch need `begin` / `end`:

```bsv
if (p) begin
   let y = x + 1;
   return y;
end
```

## Your job

| method | must return |
|---|---|
| `band(x)` | `0` when `x < 10`, `1` when `10 ≤ x < 100`, `2` when `x ≥ 100` |
| `signOf(x)` | `-1` when `x < 0`, `0` when `x == 0`, `1` when `x > 0` |

`signOf` takes an `Int#(8)`, so `<` is the signed comparison (problem 06).

## vs Verilog

The same `if`/`else` chain in an `always @(*)` block infers a latch if you forget
a branch. In BSV the missing branch is a compile error instead.

## Run it

```
Basics
```
