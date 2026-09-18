# 05 — Vectors and Functions

**Difficulty** ▮▮▯▯▯ · **Concepts** `Vector`, `map`/`fold`, static elaboration, functions as values · **Prereq** 04

---

## The Verilog you'd write

```verilog
integer i;
always @(*) begin
   count = 0;
   for (i = 0; i < 8; i = i + 1)
      count = count + x[i];
end
```

A `for` loop that the synthesiser unrolls. It works, but the loop is doing two jobs
at once — describing *what* to compute and *how to walk* the bits — and you cannot
reuse "sum these" anywhere else.

## The problem

| method | result |
|---|---|
| `popcount(x)` | number of 1 bits in an 8-bit value (0..8) |
| `reverseBits(x)` | `0b1100_0001` → `0b1000_0011` |
| `maxOf(v)` | largest element of a `Vector#(4, Bit#(8))`, unsigned |
| `incAll(v)` | every element + 1, wrapping at 255 |

**Every one of these can be done with a `for` loop. Try to do it without one.**
The reference implementation uses loops precisely so you can compare.

## Tutorial: the BSV you need

**`Vector#(n, t)`** is `n` elements of type `t`, with `n` fixed at compile time.
It is not memory and not a register file — it is just a bundle of `n` values,
laid out flat in hardware. Needs `import Vector :: *;`.

**A `Bit#(8)` and a `Vector#(8, Bit#(1))` are the same wires**, so `pack`/`unpack`
move between them:

```bsv
Vector #(8, Bit #(1)) bits = unpack (x);
Bit #(8) back = pack (bits);
```

**`map` applies a function to every element:**

```bsv
function Bit #(8) plus1 (Bit #(8) a) = a + 1;
...
return map (plus1, v);
```

That one-line `function ... = expr;` form is how you write small helpers. Define
them inside the module, above the methods.

**`foldl` collapses a vector to a single value**, threading an accumulator
left to right:

```bsv
function Bit #(4) addBit (Bit #(4) acc, Bit #(1) b) = acc + zeroExtend (b);
...
return foldl (addBit, 0, bits);     // 0 is the starting accumulator
```

**`foldl1` is the same with no starting value** — it uses the first element, which
is what you want for a maximum (there is no sensible "identity" for max):

```bsv
return foldl1 (max, v);
```

`max` is an ordinary function from the Prelude, and here it is being *passed as a
value*. Functions are first-class in BSV.

**`Vector::reverse`** does what it says. Write it qualified — plain `reverse` is
ambiguous with the `Bit` version.

## What changed from Verilog

- **The loop and the operation are separated.** `map` says "elementwise", `foldl`
  says "collapse". What you are doing sits in a named function you can test and
  reuse. Verilog's `for` fuses the two forever.
- **This is all *static elaboration*.** `map`, `foldl`, `Integer` loop counters —
  none of it exists at run time. `bsc` evaluates it during compilation and emits
  flat combinational logic. `map` is not "a loop in hardware", it is a compile-time
  instruction to lay down four copies of something. There is no cost to it.
- **Functions are values.** Passing `max` to `foldl1` has no Verilog equivalent
  short of a macro. This is what makes BSV's generic components possible.
- **`Integer` is compile-time only.** `Integer i` in a `for` loop is unbounded and
  has no hardware form. If you try to put one in a register, `bsc` will refuse —
  that is the error telling you that you meant `Bit#(n)` or `UInt#(n)`.

## How you're checked

160 randomised rounds. Each method on its own cycle, against a reference written
entirely with explicit `for` loops. The checker cannot tell whether you used loops
or `map` — but the point of the exercise is the code you end up with, so read
`SOLUTION.md` afterwards even if you pass.

## Run it

```
Run
```
