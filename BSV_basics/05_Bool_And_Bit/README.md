# 05 — Bool is not Bit#(1)

**Concept** `Bool`, `True`/`False`, and `&&` `||` `!` versus `&` `|` `~`.

## The rule

`Bool` is its own type with exactly two values, `True` and `False`. It is **not**
`Bit#(1)`, and BSV will not convert between them behind your back.

| on `Bool` | on `Bit#(n)` |
|---|---|
| `&&` `\|\|` `!` | `&` `\|` `~` |
| `True` / `False` | `1` / `0` |

Everything that asks a yes/no question gives you a `Bool`: `==`, `!=`, `<`, `>`.
Everything that takes a condition — `if`, `? :`, a rule guard — demands one.

## Example

```bsv
method Bool inRange (Bit #(8) x);
   return (x > 8'd10) && (x < 8'd20);
endmethod
```

Writing `(x > 10) & (x < 20)` there is a **type error**, not a subtle bug. That
is the point.

## Your job

| method | must return |
|---|---|
| `isEqual(a,b)` | `True` when `a` and `b` are equal |
| `bothTrue(p,q)` | `p` AND `q` |
| `notP(p)` | NOT `p` |

## vs Verilog

Verilog has one type doing both jobs, so `if (a & b)` and `if (a && b)` both
compile and mean different things. BSV splits them, and the compiler catches the
mix-up at the point you write it.

## Run it

```
Basics
```
