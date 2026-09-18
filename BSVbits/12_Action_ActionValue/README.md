# 12 — Action, ActionValue, and value methods

**Difficulty** ▮▮▯▯▯ · **Concepts** the three method kinds, `noAction`, `<-` on a method call · **Prereq** 11

---

## The Verilog you'd write

```verilog
module accumulator (
   input  wire       clk,
   input  wire       add_en,     input wire [7:0] add_x,
   input  wire       take_en,    output reg [7:0] take_result,
   output wire [7:0] total, count
);
```

Every operation is a hand-built bundle: an enable, its arguments, and — if it
returns something — an output you must sample on exactly the right cycle. Nothing
in the port list says which enable goes with which arguments. That association
lives in a comment and in your head.

## The problem

| method | kind | behaviour |
|---|---|---|
| `add(x)` | `Action` | add `x` to the total; increment the call count |
| `takeAndClear()` | `ActionValue#(Bit#(8))` | return the total **as it was**, and reset it to 0 |
| `total()` | value | the running total |
| `count()` | value | how many `add` calls; never reset |

## Tutorial: the BSV you need

**Three method kinds, and the type says which:**

| declaration | changes state? | returns? | generated ports |
|---|---|---|---|
| `method Action f (args);` | yes | no | args in, `EN_f` in, `RDY_f` out |
| `method ActionValue #(t) g (args);` | yes | yes | args in, `EN_g` in, `g` out, `RDY_g` out |
| `method t h (args);` | no | yes | args in, `h` out |

That `EN_`/`RDY_` pair is the enable-and-ready handshake you were writing by hand
in the Verilog above. `bsc` generates it, correctly, every time, and — as of
problem 13 — wires the readiness into the caller's rule condition.

**An `Action` method body is a sequence of actions:**

```bsv
method Action add (Bit #(8) x);
   total_r <= total_r + x;
   count_r <= count_r + 1;
endmethod
```

Like a rule body, it is atomic: all of it happens, or the method is not called.
`noAction` is the do-nothing action, useful as a placeholder or in an empty `case`
arm.

**An `ActionValue` method does both**, and the `return` is the value:

```bsv
method ActionValue #(Bit #(8)) takeAndClear ();
   total_r <= 0;
   return total_r;         // the OLD value -- `<=` has not landed yet
endmethod
```

The `return total_r` reads the start-of-cycle value, because `<=` is non-blocking.
"Read the old value and clear" falls out of the semantics; you do not sequence it.

**Calling an ActionValue needs `<-`, not `=`:**

```bsv
let v <- dut.takeAndClear ();     // performs the action AND binds the result
let w =  dut.total ();            // pure read, no action
```

This is the same `<-` as module instantiation, and for the same reason: something
is happening, not merely being computed. If you write `=` where `<-` is needed,
`bsc` will tell you it expected an `ActionValue`.

**A value method can be a one-liner**, and often should be:

```bsv
method Bit #(8) total () = total_r;
```

## What changed from Verilog

- **The enable and the arguments are one thing.** A method is a named, typed
  operation. You cannot assert `add_en` while driving the wrong argument bundle,
  because there is only one way to call `add`.
- **`RDY` is generated even when you did not ask.** Here every method is always
  ready, so `RDY` is constant 1. In problem 13 you make it mean something, and the
  wiring does not change.
- **Read-and-modify is one operation.** `takeAndClear` returns the old value and
  writes the new one atomically. In Verilog this is a two-cycle protocol or a
  careful bit of combinational care; here it is the default semantics of `<=`.
- **The `<-` / `=` distinction is enforced.** The type system knows which calls
  have side effects. You cannot silently drop an action by binding it with `=`.

## How you're checked

120 rounds. Both modules get an identical call sequence, with a `takeAndClear`
roughly one round in four; the returned value and the state left behind are both
compared. The reference uses the explicit `._read` / `._write` forms that `<=` is
sugar for — worth a look, since it shows that `Reg` is just another interface.

## Run it

```
Run
```
