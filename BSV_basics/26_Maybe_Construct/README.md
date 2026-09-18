# 26 — Maybe

**Concept** `Maybe#(t)` — a value, or the explicit absence of one.

## The rule

`Maybe#(t)` holds either a `t` or nothing:

```bsv
Maybe #(Bit #(8)) a = tagged Valid 8'h42;
Maybe #(Bit #(8)) b = tagged Invalid;
```

In hardware it is `t` plus **one extra bit** — the valid flag you would have
carried as a separate `data_valid` wire in Verilog. The difference is that here
the flag and the data are one value, so they cannot be routed to different places
or checked in the wrong order.

`Maybe` is built into the Prelude. There is nothing to import and nothing to
declare.

`tagged` is the keyword that introduces a tagged-union value. You will see it
again on `case` in problem 28.

## Example

```bsv
method Maybe #(Bit #(4)) lookup (Bool hit, Bit #(4) v);
   return hit ? tagged Valid v : tagged Invalid;
endmethod
```

## Your job

| method | must return |
|---|---|
| `wrap(x)` | `x`, tagged valid |
| `nothing()` | the invalid value |
| `maybeVal(ok,x)` | `x` when `ok`, otherwise invalid |

## vs Verilog

A `data` bus and a `data_valid` bit, related only by naming convention. Half of
"why is this register garbage?" is that convention being broken somewhere. Here
reading the data at all forces you to deal with the flag (problems 27 and 28).

## Run it

```
Basics
```
