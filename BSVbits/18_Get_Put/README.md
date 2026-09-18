# 18 — Get, Put and mkConnection

**Difficulty** ▮▮▮▯▯ · **Concepts** `Get`/`Put`, `toGet`/`toPut`, `mkConnection`, subinterfaces · **Prereq** 17

---

## The Verilog you'd write

Two modules, and between them a bundle you name by hand at both ends —
`a_out_data` / `a_out_valid` / `a_out_ready` wired to `b_in_data` / `b_in_valid` /
`b_in_ready` — praying you got the polarity of `ready` the same in both. Then you do
it again for the next pair, and again.

## The problem

Build two stages and connect them with **one line**:

| module | in | out | does |
|---|---|---|---|
| `mkAddOne` | `Bit#(8)` | `Bit#(8)` | `x + 1` |
| `mkTimesThree` | `Bit#(8)` | `Bit#(16)` | `x * 3` |

Each exposes `interface Put#(a) inp` and `interface Get#(b) outp`. Then `mkTop`
instantiates both, joins them with `mkConnection`, and exposes the outer ends.
Overall: `(x + 1) * 3`.

## Tutorial: the BSV you need

**`Get` and `Put` are the two standard one-directional interfaces:**

```bsv
interface Get #(t);  method ActionValue #(t) get (); endinterface
interface Put #(t);  method Action put (t x);        endinterface
```

That is all they are. The value is that they are *standard* — every BSV library
component that produces or consumes a stream speaks them, so anything can plug into
anything.

**A `FIFOF` converts to both, for free:**

```bsv
interface inp  = toPut (inQ);     // Put that enqueues
interface outp = toGet (outQ);    // Get that dequeues (deq + first)
```

`toGet`/`toPut` are adapters from `GetPut`. They carry the FIFO's guards with them,
so the readiness propagates exactly as before.

**A subinterface is defined with `interface … endinterface`**, or with `=` when you
are handing over something that already exists — as above. Both forms appear in this
problem.

**`mkConnection` joins any two things that fit:**

```bsv
mkConnection (a.outp, b.inp);      // Get#(t) to Put#(t)
```

This generates the rule you would otherwise write by hand:

```bsv
rule connect;                      // what mkConnection does for you
   let x <- a.outp.get ();
   b.inp.put (x);
endrule
```

It fires when `a` has something and `b` has room, because both methods are guarded.
The line is identical whatever the two modules are — that is the payoff of standard
names.

`mkConnection` is a typeclass (`Connectable`, problem 15), which is why the same
call also joins `Client` to `Server`, two `FIFOF`s, or your own types once you
write the instance.

## What changed from Verilog

- **The interconnect has a name and a type.** `Get#(Bit#(8))` to `Put#(Bit#(8))`
  either typechecks or does not. There is no way to wire the valid of one thing to
  the ready of another.
- **One line replaces a bundle of wires and a handshake.** And it is the *same*
  line every time, so it cannot be got wrong in a novel way on the ninth use.
- **Direction is in the type.** `Get` produces, `Put` consumes. `mkConnection(a.inp,
  b.inp)` does not compile.
- **Composition scales.** Three stages is two `mkConnection` calls. In Verilog it is
  two more wire bundles to name, declare and match up.

## How you're checked

100 values through the chain, compared against a reference that applies the whole
function in one method with no stages at all. Capacities differ, so the testbench
never assumes when a result is ready.

## Run it

```
Run
```
