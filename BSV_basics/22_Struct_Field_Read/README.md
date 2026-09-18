# 22 — Reading Struct Fields

**Concept** `p.field` — and that reading a struct costs nothing.

## The rule

Fields come out by name, with a dot:

```bsv
Bit #(8) a = p.x;
Bit #(8) b = p.y + 1;
```

That is it. No index, no width, no mask, no shift — and no way to read the wrong
bits, because you never mention bits.

Reading a field is **pure wiring**: `p.x` names eight of the sixteen wires that
`p` already is. It generates nothing.

To build a modified copy, construct a new one (problem 21) from the old one's
fields:

```bsv
Point moved = Point { x: p.x + 1, y: p.y };
```

Structs are values, not variables. `p.x = 5;` is not a thing — you make a new
`Point` instead.

## Your job

| method | must return |
|---|---|
| `getX(p)` | `p.x` |
| `getY(p)` | `p.y` |
| `sumXY(p)` | `p.x + p.y`, wrapping at 8 bits |
| `swapXY(p)` | a `Point` with `x` and `y` exchanged |

## vs Verilog

`raw[15:8]` and `raw[7:0]`, with the layout living in a comment. Widen `x` to 12
bits and every one of those slices has to be found and corrected. Here you widen
the field in the `typedef` and `p.x` still means `p.x`.

## Run it

```
Basics
```
