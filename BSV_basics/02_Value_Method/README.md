# 02 — Value Methods with Arguments

**Concept** method arguments are input wires; the return value is output wires.

## The rule

A value method's arguments become input ports on the generated module and its
result becomes output ports. Arguments are matched **by position**, and each one
carries its own type and width.

## Example

```bsv
method Bit #(4) firstOf (Bit #(4) x, Bit #(4) y);
   return x;
endmethod
```

## Your job

| method | must return |
|---|---|
| `same(a)` | `a` |
| `second(a, b)` | `b` |

## vs Verilog

`assign out = a;` — same hardware, same zero gates. The difference is that the
port list is named and typed instead of being a flat bundle of wires.

## Run it

```
Basics
```
