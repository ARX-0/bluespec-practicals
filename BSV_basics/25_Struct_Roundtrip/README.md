# 25 — Decode, Encode, Execute

**Concept** everything from 18–24, together. This problem **is** BSVbits 04.

## The rule

Nothing new. You already have all three pieces:

- an enum inside a struct is just another field (problem 21) — `Opcode` is 2 bits
  wide, so `Instr` is 2 + 4 + 4 = 10;
- `unpack` splits raw bits into the fields, `pack` puts them back (23, 24);
- a `case` over the enum applies the operation (20).

## The types (already in `Top.bsv`)

```bsv
typedef enum { OpAdd, OpSub, OpAnd, OpOr }
   Opcode deriving (Bits, Eq, FShow);

typedef struct {
   Opcode   op;      // bits [9:8]
   Bit #(4) rd;      // bits [7:4]
   Bit #(4) rs;      // bits [3:0]
} Instr deriving (Bits, Eq, FShow);
```

## Your job

| method | must return |
|---|---|
| `decode(raw)` | the `Instr` those 10 bits describe |
| `encode(i)` | those 10 bits back — the exact inverse |
| `execute(op,x,y)` | `x+y`, `x-y`, `x&y`, `x\|y` |

`decode` and `encode` are **one line each**. If you are writing bit indices, stop
and re-read problem 24.

## vs Verilog

```verilog
localparam OP_ADD = 2'b00, OP_SUB = 2'b01, OP_AND = 2'b10, OP_OR = 2'b11;
wire [1:0] op = raw[9:8];
wire [3:0] rd = raw[7:4];
wire [3:0] rs = raw[3:0];
```

Plus the matching four lines on the encode side, plus a comment describing the
layout, all of which must be kept in step by hand. Widening `rd` to 5 bits means
finding every one of them. Here you change the `typedef` and stop.

## When this passes

Open `BSVbits/04_Struct_And_Enum/`. It is this problem, and you can now read it.

## Run it

```
Basics
```
