# 03 — Adders and Bit Widths

**Difficulty** ▮▮▯▯▯ · **Concepts** numeric types, `zeroExtend`/`signExtend`/`truncate`, width inference · **Prereq** 02

---

## The Verilog you'd write

```verilog
assign {cout, sum} = a + b + cin;   // and hope the widths worked out
assign zext = {8'b0, x};
assign sext = {{8{x[7]}}, x};
assign trunc = x[7:0];
```

Verilog's width rules are context-dependent and mostly invisible: the width of
`a + b` depends on the width of what you assign it to. Get it wrong and the result
is a silent truncation, at worst a warning you have learned to scroll past.

## The problem

| method | result |
|---|---|
| `add8(a,b,cin)` | 9-bit sum. Bit 8 is the carry-out. Nothing is lost. |
| `zext(x)` | 8 → 16 bits, high bits zero |
| `sext(x)` | 8 → 16 bits, high bits copy `x[7]` |
| `trunc(x)` | 16 → 8 bits, keep the low byte |

`add8(0xFF, 0xFF, 1)` must be `0x1FF`.

## Tutorial: the BSV you need

**Widths are part of the type and are checked.** `Bit#(8) + Bit#(8)` is `Bit#(8)`.
Adding two bytes and expecting nine bits will not compile — and that is the feature.
To keep the carry you must widen *first*:

```bsv
return { 1'b0, a } + { 1'b0, b } + { 8'b0, cin };
```

Every term is now `Bit#(9)`, so the sum is `Bit#(9)` and the carry has somewhere to go.

**The three width-changing functions:**

```bsv
zeroExtend (x)    // narrow -> wide, pad with 0
signExtend (x)    // narrow -> wide, pad with the sign bit
truncate  (x)     // wide -> narrow, keep the low bits
```

They are *polymorphic*: they work at any pair of widths, and figure out the target
width from context — the method's declared return type here. You do not write the
numbers.

**Numeric types.** When you do need to compute a width, BSV has type-level
arithmetic: `TAdd#(n,1)`, `TMul#(n,2)`, `TLog#(n)`, `TSub#(n,1)`. A generic adder
would be declared:

```bsv
method Bit #(TAdd #(n, 1)) addN (Bit #(n) a, Bit #(n) b);
```

You do not need that here — it is problem 14 — but this is where those types come from.

## What changed from Verilog

- **Width mismatches are compile errors, not warnings.** The single largest
  category of "the RTL is subtly wrong" bugs stops existing. In exchange, you write
  `zeroExtend` where Verilog let you say nothing.
- **Extension is explicit and named.** `zeroExtend` vs `signExtend` at the point of
  use, rather than depending on how the operands were declared several files away.
- **`truncate` is a statement of intent.** Verilog truncates silently; in BSV
  throwing bits away is something you had to type.
- **Width inference flows backwards.** `zeroExtend(x)` has no width of its own — it
  takes one from where the result goes. If `bsc` complains it cannot determine a
  width, add a type annotation: `Bit#(16) w = zeroExtend(x);`

## How you're checked

160 randomised rounds, plus the `0xFF + 0xFF + 1` carry corner forced on round 0.
The reference builds the sum with an explicit ripple-carry loop, so it agrees with
you about the carry-out but shares no code with the answer.

## Run it

```
Run
```
