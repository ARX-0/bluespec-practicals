# 24 — unpack into a Struct

**Concept** the inverse of problem 23, in one call.

## The rule

```bsv
Header h = unpack (raw);      // Bit#(16) -> Header
```

`unpack` splits the raw bits across the fields using the same
declaration-order layout `pack` used. It is the exact inverse, it costs nothing,
and — as in problem 07 — you never name the type: `bsc` picks the right `unpack`
from the type the result is used as.

That is the whole of instruction decoding, bus-transaction parsing and packet
header parsing in BSV. One line.

## Example

```bsv
method Bit #(8) payloadOf (Bit #(16) raw);
   Header h = unpack (raw);
   return h.payload;
endmethod
```

Note the `Header h = ...` — the local's declared type is what tells `unpack`
which struct to build. Writing `let h = unpack (raw);` gives an error about an
ambiguous type, and that error is worth meeting once.

## Your job

| method | must return |
|---|---|
| `fromBits(raw)` | the `Header` those 16 bits describe |
| `tagOf(raw)` | just the `tag` field — `unpack` first, then read the field |

Neither body may contain a bit index.

## vs Verilog

```verilog
wire [3:0] tag = raw[15:12];
wire [3:0] len = raw[11:8];
wire [7:0] pay = raw[7:0];
```

Three lines that must agree with the three lines on the encode side, and with a
comment. `unpack` is those three lines derived from the type, so they cannot
drift apart.

## Run it

```
Basics
```
