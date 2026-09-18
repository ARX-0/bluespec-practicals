# 14 — Polymorphic modules and provisos

**Difficulty** ▮▮▮▮▯ · **Concepts** `numeric type`, `type`, `provisos`, `TLog#`, generic modules · **Prereq** 13

---

## The Verilog you'd write

```verilog
module bank #(parameter N = 8, parameter W = 8) (...);
   reg [W-1:0] mem [0:N-1];
```

Parameterised on *widths*, which is as far as Verilog goes. To store a struct you
flatten it to a bit vector at every call site and unflatten it on the way out,
by hand, and `bank` has no idea what it is holding. `$clog2(N)` for the index width
is computed but never checked against what callers pass.

## The problem

Write **one** module, `mkBank`, generic in both its size and its element type:

```bsv
interface Bank_IFC #(numeric type n, type t);
   method Action upd (Bit #(TLog #(n)) idx, t v);
   method t      sub (Bit #(TLog #(n)) idx);
endinterface
```

Then `mkTop` instantiates it **twice**, at different sizes *and* different element
types — 8 bytes, and 4 `Pair` structs — and wires its four methods through.

Note `mkBank` has no `(* synthesize *)`. A polymorphic module has no single piece of
hardware to name until it is instantiated.

## Tutorial: the BSV you need

**Two kinds of parameter:**

```bsv
interface Bank_IFC #(numeric type n, type t);
```

- `numeric type n` — a compile-time **number** (a size). Lives in the type system;
  you do arithmetic on it with `TAdd#`, `TLog#`, `TMul#`, `TSub#`.
- `type t` — a compile-time **type**. Any type at all, so long as it satisfies
  whatever the module needs of it.

`TLog#(n)` is ⌈log₂ n⌉ — the index width for `n` entries, computed by the compiler
and *checked* against every caller. `TLog#(8)` is 3, `TLog#(4)` is 2.

**A proviso is a constraint on a type parameter.** `mkBank` needs to store values of
type `t` in registers, which requires knowing `t` has a bit representation:

```bsv
module mkBank (Bank_IFC #(n, t))
   provisos (Bits #(t, sz));
```

Read `Bits#(t, sz)` as: "`t` can be packed into bits, and `sz` is how many." `sz`
is introduced by the proviso — you do not declare it, and you rarely mention it
again.

**Leave the proviso out on purpose the first time.** `bsc` will tell you exactly
which one is missing and where. That error message is one of the genuinely good
things about the compiler, and you should see it once deliberately rather than
meeting it under pressure.

**The body then writes itself:**

```bsv
Vector #(n, Reg #(t)) rs <- replicateM (mkReg (unpack (0)));
```

`unpack(0)` is "the all-zeros value of type `t`", which typechecks precisely
because of the `Bits#(t, sz)` proviso.

**Instantiating at concrete types:**

```bsv
Bank_IFC #(8, Bit #(8)) bytes <- mkBank;
Bank_IFC #(4, Pair)     pairs <- mkBank;
```

Same module, twice, at different sizes and types. `bsc` elaborates two distinct
pieces of hardware.

## What changed from Verilog

- **Generic over types, not just widths.** `mkBank` stores `Pair`s without knowing
  what a `Pair` is, and callers get `Pair` in and out — no manual flatten/unflatten,
  no chance of packing it inconsistently in two places.
- **The index width is derived and enforced.** `Bit#(TLog#(n))` means an 8-entry
  bank takes a 3-bit index, checked at every call. Verilog's `$clog2(N)` computes
  the same number and enforces nothing.
- **Requirements are declared, not discovered.** A proviso states what the module
  needs of its type parameter, up front. Instantiating at a type that does not
  qualify is a compile error at the instantiation site, naming the missing
  constraint — not a strange failure inside a module you did not write.
- **This is how the whole standard library is built.** `FIFO#(t)`, `Vector#(n,t)`,
  `RegFile#(a,d)`, `Get#(t)`, `Server#(req,resp)` are all exactly this pattern. From
  here on you are reading library code, not incanting it.

## How you're checked

200 randomised rounds writing and reading both banks, including a read of an
*untouched* slot each round to catch a bank that writes everywhere. The reference is
two separate hand-written banks with no polymorphism — the thing you would have had
to write twice.

## Run it

```
Run
```
