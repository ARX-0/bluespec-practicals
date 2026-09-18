# 27 — Asking a Maybe What It Holds

**Concept** `isValid` and `fromMaybe`.

## The rule

Two Prelude functions cover most uses:

```bsv
isValid   (m)        // Bool   -- is there a value?
fromMaybe (dflt, m)  // t      -- the value, or dflt when there is none
```

Note the argument order: **the default comes first.**

`fromMaybe` is the important one. There is no function that just hands you the
contents, because there might not be any — so every read has to say what happens
when there is nothing. In Verilog that decision is made by whatever the data bus
happened to be holding.

## Example

```bsv
method Bit #(4) sizeOr1 (Maybe #(Bit #(4)) m);
   return fromMaybe (1, m);
endmethod
```

## Your job

| method | must return |
|---|---|
| `valid(m)` | `True` when `m` holds a value |
| `orZero(m)` | the value, or `0` |
| `orElse(m,d)` | the value, or `d` |

Each is one call.

## Run it

```
Basics
```
