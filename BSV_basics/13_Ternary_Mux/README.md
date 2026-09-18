# 13 — The Ternary Operator

**Concept** `cond ? x : y` — and that the condition must be a `Bool`.

## The rule

```bsv
return sel ? b : a;
```

is a two-input multiplexer, exactly as in Verilog. The one difference: **`sel`
must be a `Bool`**. A `Bit#(1)` is not a condition, so you convert it — usually
by comparing it, which produces a `Bool`:

```bsv
return (sel == 1) ? b : a;      // sel is Bit#(1)
```

Both arms must have the same type, and that type is the type of the whole
expression.

## Example

```bsv
method Bit #(8) clampTop (Bit #(8) x);
   return (x > 8'd200) ? 8'd200 : x;
endmethod
```

## Your job

| method | must return |
|---|---|
| `mux2(sel,a,b)` | `a` when `sel` is `False`, `b` when `True` |
| `mux2b(sel,a,b)` | same, with `sel` a `Bit#(1)` |
| `maxOf(a,b)` | the larger of `a` and `b` |

## Run it

```
Basics
```
