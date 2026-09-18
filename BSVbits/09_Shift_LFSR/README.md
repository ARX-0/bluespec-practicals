# 09 — Shift Registers and an LFSR

**Difficulty** ▮▮▯▯▯ · **Concepts** `Vector` of registers, `replicateM`, feedback · **Prereq** 08

---

## The Verilog you'd write

```verilog
reg [7:0] s;
reg [2:0] d;
always @(posedge clk) begin
   s <= {s[6:0], s[7]^s[5]^s[4]^s[3]};
   d <= {d[1:0], s[0]};
end
```

A shift register is a concatenation and an assignment. Nothing to it — until the
delay line needs its own enable, or per-stage taps, at which point packing three
independent flops into one `reg [2:0]` starts to hurt.

## The problem

| method | behaviour |
|---|---|
| `lfsr` | 8-bit LFSR, seeded `0xFF`, shifting **left** once per cycle. New bit is `s[7]^s[5]^s[4]^s[3]`, shifted in at the bottom. |
| `delayed3` | a 3-deep delay line fed with `s[0]` (sampled *before* each shift); returns the bit that entered 3 cycles ago. Starts 0. |

Build the delay line as a **`Vector` of registers**, not a packed `Bit#(3)`.

## Tutorial: the BSV you need

**A vector of registers is not the same as a register holding a vector.**

```bsv
Vector #(3, Reg #(Bit #(1))) dl <- replicateM (mkReg (0));   // 3 separate flops
Reg #(Vector #(3, Bit #(1)))  r <- mkReg (replicate (0));    // 1 flop holding 3 bits
```

The first gives you three independently-writable registers you can index. The
second is a single register whose contents happen to be a vector — you must write
all of it at once. For a delay line with per-stage control you want the first.

**`replicateM` instantiates a module n times.** The `M` means "monadic" — it is
doing something effectful (instantiating hardware), which is why it needs `<-`:

```bsv
Vector #(3, Reg #(Bit #(1))) dl <- replicateM (mkReg (0));
```

Compare `replicate(0)`, with no `M`, which just builds a vector of three zeros —
a pure value, bound with `=`.

**Index with `[]`, and each element is a full `Reg`:**

```bsv
dl[0] <= s[0];
dl[1] <= dl[0];
```

**A static `for` loop writes the shift compactly:**

```bsv
for (Integer i = 1; i < 3; i = i + 1)
   dl[i] <= dl[i - 1];
```

This is compile-time elaboration (problem 05) — `bsc` unrolls it into two separate
register writes. `Integer i` never exists in hardware.

**Left shift with feedback** is Verilog's concatenation:

```bsv
s <= { s[6:0], nb };
```

## What changed from Verilog

- **Stages are addressable.** `dl[i]` is a real register with its own write. Giving
  stage 2 an enable, or tapping stage 1 from another rule, is a local change. In the
  packed `reg [2:0]` version every stage shares one assignment.
- **`replicateM` scales.** A 3-deep line and a 64-deep line differ by one number,
  and `Vector#(n, Reg#(t))` with `n` a type parameter is how you write a
  depth-generic delay line (problem 14).
- **`<-` vs `=` again.** `replicateM(mkReg(0))` instantiates hardware, so `<-`.
  `replicate(0)` computes a value, so `=`. The `M` in the name is the tell.

## How you're checked

255 cycles — a full LFSR period — comparing both outputs every cycle. The reference
uses a packed `Bit#(3)` for the delay line, so it agrees on behaviour while using
the style you are being steered away from. Read it afterwards.

## Run it

```
Run
```
