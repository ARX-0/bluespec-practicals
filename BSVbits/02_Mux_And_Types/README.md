# 02 — Muxes and Types

**Difficulty** ▮▯▯▯▯ · **Concepts** `case`, concatenation, bit selection, `Bit`/`UInt`/`Int`, `Bool` · **Prereq** 01

---

## The Verilog you'd write

```verilog
always @(*) case (sel)
   2'd0: y = d0;  2'd1: y = d1;
   2'd2: y = d2;  2'd3: y = d3;
endcase

assign swapped = {x[3:0], x[7:4]};
assign ugt     = (a > b);              // unsigned, because `wire [7:0]`
assign sgt     = ($signed(a) > $signed(b));
```

Note that last line. In Verilog, `a > b` means unsigned or signed depending on
how `a` and `b` were *declared*, and you patch it at the point of use with
`$signed()`. That is the part BSV changes.

## The problem

| method | result |
|---|---|
| `mux4(sel,d0..d3)` | the selected byte |
| `swapNibbles(x)` | `0xAB` → `0xBA` |
| `ugt(a,b)` | `a > b` treating both as **unsigned** 0..255 |
| `sgt(a,b)` | `a > b` treating both as **signed** −128..127 |

`ugt(0x80, 0x01)` is `True` (128 > 1). `sgt(0x80, 0x01)` is `False` (−128 < 1).
Same bits, different answer — that is the whole lesson.

## Tutorial: the BSV you need

**`case` as an expression.** BSV's `case` returns a value, so you can `return` it
directly:

```bsv
return case (sel)
          0: d0;
          1: d1;
          2: d2;
          default: d3;
       endcase;
```

`default` is not optional here — `bsc` insists every case is covered, because
there is no `x` to fall back to.

**Concatenation and selection** are Verilog's, with braces:

```bsv
{ x[3:0], x[7:4] }        // 8 bits, nibbles swapped
```

**Three number types, not one:**

| type | meaning | `>` does |
|---|---|---|
| `Bit#(8)` | 8 raw bits | unsigned compare |
| `UInt#(8)` | unsigned integer 0..255 | unsigned compare |
| `Int#(8)` | signed integer −128..127 | **signed** compare |

They all occupy 8 wires. You convert between them with `pack` (to `Bit`) and
`unpack` (from `Bit`) — free, no gates:

```bsv
Int #(8) ia = unpack (a);
```

**`Bool` is a fourth, separate thing.** `True`/`False`, the result of `==`, `>`,
`&&`. It is not `Bit#(1)` and will not convert on its own.

## What changed from Verilog

- **Signedness lives in the type, not at the point of use.** No `$signed()`
  sprinkled at comparison sites, and no rule about "if any operand is unsigned the
  whole expression is unsigned" to memorise. You say what the number *is*, once.
- **`case` must be total.** Verilog lets an incomplete `case` infer a latch. BSV
  has no latches and no `x`, so it makes you write `default`.
- **`Bool` and `Bit#(1)` are different types.** `if (sel)` where `sel` is
  `Bit#(1)` is a type error. Write `if (sel == 1)`. This feels pedantic for about
  a day and then starts catching real bugs.

## How you're checked

128 randomised rounds against the reference, each method on its own cycle. The
seed is fixed, so a failure is reproducible.

## Run it

```
Run
```
