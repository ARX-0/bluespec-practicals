# 18 — Declaring an Enum

**Concept** `typedef enum`, and what `deriving` is for.

## The rule

```bsv
typedef enum { Idle, Busy, Done }
   State deriving (Bits, Eq, FShow);
```

That declares a **type** called `State` with exactly three values. `Idle` is not
a name for `0` — it is a value of type `State`, and comparing it to `0` is a type
error.

`deriving` is the compiler generating the boring parts for you:

| clause | gives you |
|---|---|
| `Bits` | `pack` / `unpack` — the type can live on wires and in registers |
| `Eq` | `==` and `!=` |
| `FShow` | `fshow(x)` — prints the value **by name** in simulation |

**Without `Bits` the type cannot be hardware at all.** Ask for all three; you
will want them.

The encoding is **declaration order**, starting at 0, in the narrowest width that
fits: `Idle` is `2'b00`, `Busy` is `2'b01`, `Done` is `2'b10`. You do not choose
the numbers and you should not need to know them.

## Your job

Declare, at package level in `Top.bsv`:

```
an enum type named Color with values Red, Green, Blue -- in that order --
deriving Bits, Eq and FShow
```

Then return each one's encoding:

| method | must return |
|---|---|
| `redBits()` | `pack (Red)` |
| `greenBits()` | `pack (Green)` |
| `blueBits()` | `pack (Blue)` |

## vs Verilog

`localparam RED = 2'd0, GREEN = 2'd1, BLUE = 2'd2;` — three constants of the same
type as everything else, so nothing stops you assigning `RED` to a counter. Here
they are values of a distinct type that only fits where a `Color` is expected.

## Run it

```
Basics
```
