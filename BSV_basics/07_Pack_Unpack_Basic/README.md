# 07 — pack and unpack

**Concept** the two functions that move any value on and off raw wires.

## The rule

Problems 05 and 06 said BSV will not convert between types for you. `pack` and
`unpack` are how you ask for the conversion explicitly:

```
pack   : your type  ->  Bit#(n)
unpack : Bit#(n)    ->  your type
```

They work on **every** type that derives `Bits` — `Bool`, `UInt`, `Int`, and
later your own structs and enums. They cost **zero gates**: it is the same `n`
wires read two different ways. `pack` is only renaming.

You never write the width. BSV works out which `unpack` you meant from the type
the result is being used as — here, the method's declared return type.

## Example

```bsv
Bool      flag = True;
Bit #(1)  raw  = pack (flag);      // 1
UInt #(4) n    = unpack (4'hB);    // 11
```

## Your job

| method | must return |
|---|---|
| `toBit(p)` | `p` as one bit (`True` → 1) |
| `toBool(b)` | that bit back as a `Bool` |
| `uToBits(u)` | the raw bits of `u` |
| `bitsToU(b)` | those bits back as a `UInt#(8)` |

Each body is one call.

## vs Verilog

There is no equivalent, because Verilog never stopped you from mixing the types
in the first place. `pack`/`unpack` is the price of the checking — and it buys
you the whole of problem 24, where the same two functions lay out a struct.

## Run it

```
Basics
```
