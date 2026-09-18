# 04 — Structs and Enums

**Difficulty** ▮▮▯▯▯ · **Concepts** `typedef enum`, `typedef struct`, `deriving`, `pack`/`unpack`, `fshow` · **Prereq** 03

---

## The Verilog you'd write

```verilog
localparam OP_ADD = 2'b00, OP_SUB = 2'b01, OP_AND = 2'b10, OP_OR = 2'b11;

wire [1:0] op = raw[9:8];
wire [3:0] rd = raw[7:4];
wire [3:0] rs = raw[3:0];
```

Three `localparam`s, a comment somewhere describing the bit layout, and every site
that touches an instruction re-deriving `raw[7:4]` from memory. Change the field
widths and you go hunting.

## The problem

The types are already declared in `Top.bsv` — **do not change them**:

```bsv
typedef enum { OpAdd, OpSub, OpAnd, OpOr }
   Opcode deriving (Bits, Eq, FShow);

typedef struct {
   Opcode   op;      // bits [9:8]
   Bit #(4) rd;      // bits [7:4]
   Bit #(4) rs;      // bits [3:0]
} Instr deriving (Bits, Eq, FShow);
```

| method | result |
|---|---|
| `decode(raw)` | 10 raw bits → an `Instr` |
| `encode(i)` | an `Instr` → 10 raw bits (the inverse) |
| `execute(op,x,y)` | apply the operation to two bytes |

`execute` is `+`, `−`, `&`, `|` for the four opcodes.

## Tutorial: the BSV you need

**An enum is a real type.** `Opcode` is not "a `Bit#(2)` I promise to only put four
values in" — it is a type with exactly four values. You cannot accidentally compare
one to `3`, and a `case` over it is checked for completeness.

**`deriving` is what makes it usable.** Three things you almost always want:

| clause | gives you |
|---|---|
| `Bits` | `pack`/`unpack` — the type can travel on wires and live in a register |
| `Eq` | `==` and `!=` |
| `FShow` | `fshow(x)` — printing the value by *name* in simulation |

Without `Bits`, a type is compile-time only and cannot be hardware.

**The struct's bit layout is declaration order, first field highest.** So `Instr`
packs as `{op[1:0], rd[3:0], rs[3:0]}` — 10 bits. You never write those indices.

**`pack` and `unpack` do the whole conversion at once:**

```bsv
Instr i = unpack (raw);      // 10 bits -> struct
Bit #(10) raw = pack (i);    // struct -> 10 bits
```

They cost nothing — it is the same ten wires either way.

**Constructing and reading a struct:**

```bsv
Instr i = Instr { op: OpAdd, rd: 3, rs: 7 };
let r = i.rd;
```

**`case` over an enum:**

```bsv
case (op)
   OpAdd: return x + y;
   OpSub: return x - y;
   OpAnd: return x & y;
   OpOr:  return x | y;
endcase
```

Because `Opcode` has exactly four values and you covered four, no `default` is
needed — and if you add a fifth opcode later, `bsc` will tell you about this `case`.

## What changed from Verilog

- **The bit layout is written once, in the type.** Widen `rd` to 5 bits and every
  `pack`/`unpack` in the design adjusts. Nothing else changes. This is the single
  biggest day-to-day productivity difference from Verilog.
- **Opcodes have names in the waveform and in `$display`.** `fshow(op)` prints
  `OpSub`, not `2'b01`. The testbench for this problem uses it — look at the failure
  output.
- **A `case` over an enum can be exhaustive**, so omitting `default` is safe and
  the compiler protects you when the enum grows. Contrast Verilog, where omitting
  `default` infers a latch.
- **You cannot mix up field order.** `Instr { op: ..., rd: ..., rs: ... }` is by
  name. There is no positional construction to get subtly wrong.

## How you're checked

160 randomised rounds. `decode` is compared structurally, `encode` is checked as the
round-trip inverse of the reference's `decode`, and `execute` is checked on random
operands for every opcode. Failures print with `fshow`, so you see `OpSub` rather
than a number.

## Run it

```
Run
```
