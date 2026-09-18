# 01 — Wires and Gates

**Difficulty** ▮▯▯▯▯ · **Concepts** package, interface, value method, `(* synthesize *)` · **Prereq** none

---

## The Verilog you'd write

```verilog
module gates (
   input  wire a, b, sel,
   output wire y_nand, y_nor, y_xnor, y_mux
);
   assign y_nand = ~(a & b);
   assign y_nor  = ~(a | b);
   assign y_xnor = ~(a ^ b);
   assign y_mux  = sel ? b : a;
endmodule
```

Four `assign` statements. Nothing clocked, nothing stateful.

## The problem

Implement the same four functions in BSV. The interface is already written in
`Top.bsv` — **do not change it**, the checker instantiates your module through it:

```bsv
interface Gates_IFC;
   method Bit #(1) nand2 (Bit #(1) a, Bit #(1) b);
   method Bit #(1) nor2  (Bit #(1) a, Bit #(1) b);
   method Bit #(1) xnor2 (Bit #(1) a, Bit #(1) b);
   method Bit #(1) mux2  (Bit #(1) sel, Bit #(1) a, Bit #(1) b);
endinterface
```

| method | result |
|---|---|
| `nand2(a,b)` | NOT (a AND b) |
| `nor2(a,b)`  | NOT (a OR b) |
| `xnor2(a,b)` | 1 when `a == b` |
| `mux2(sel,a,b)` | `a` when `sel==0`, `b` when `sel==1` |

## Tutorial: the BSV you need

**Everything lives in a package.** The file is `Top.bsv`, so the package is `Top`:

```bsv
package Top;
   ...
endpackage
```

**An interface is the module's port list** — but a *typed, named* one. Where Verilog
gives you a flat bag of wires and leaves the protocol in your head, BSV groups the
wires into named methods.

**A value method is an `assign`.** It takes arguments, returns a value, and has no
`Action` in its type, so it cannot change state:

```bsv
method Bit #(1) nand2 (Bit #(1) a, Bit #(1) b);
   return ~(a & b);
endmethod
```

The arguments become input wires on the generated module; the return value becomes
output wires. There is no clock involved.

**The operators are the ones you know**: `&` `|` `^` `~` all work on `Bit#(n)`,
bitwise, exactly as in Verilog.

**`(* synthesize *)`** tells `bsc` to emit this module as its own Verilog module
rather than inlining it into its parent. Without it your module still works, it just
disappears into the caller's RTL. Keep it — it is what makes the generated Verilog
readable.

## What changed from Verilog

- **A method is not a port, it is a named bundle of ports.** `nand2` becomes
  `nand2_a`, `nand2_b` inputs and a `nand2` output in the generated Verilog. Run
  `Run -v` after you pass and read `outputs/verilog/mkTop.v` — it is worth seeing
  once, early, that BSV really does compile to ordinary RTL.
- **`Bit#(1)` is a one-bit vector, not a `bit`.** BSV's types are sized and checked.
  `Bit#(1)` and `Bit#(8)` are different types and will not silently mix — no implicit
  width extension, no truncation warning you learn to ignore.
- **There is no `x`.** BSV has no unknown value. A register always holds a definite
  value from reset. Half of what you use Verilog simulation for — chasing red `x`
  through a waveform — simply does not arise.
- **`return` inside a method**, not an assignment to the output name.

## How you're checked

`.check/Testbench.bsv` instantiates your `mkTop` and the golden `mkRef` side by side,
drives both with all 8 combinations of `(sel, b, a)`, and compares all four methods —
each on its own cycle, so a failure names exactly one method. 32 checks total.

The stub you start with returns `0` from every method, so your first `Run` will fail
with 16 of 32 checks passing. That is expected: it confirms the checker is live before
you have written anything.

## Run it

```
Run
```

from inside this directory. Then `Run -v` to see it through generated Verilog, or
`Run -w` to get a waveform.
