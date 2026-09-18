# 11 — RWires and DWires

**Difficulty** ▮▮▮▯▯ · **Concepts** `mkRWire`, `wset`/`wget`, `Maybe`, `mkDWire` · **Prereq** 10

---

## The Verilog you'd write

```verilog
wire        pulse_valid = (tick[1:0] == 2'b00);
wire [7:0]  pulse_data  = tick;

always @(posedge clk) begin
   tick <= tick + 1;
   if (pulse_valid) begin
      hits <= hits + 1;
      last <= pulse_data;
   end
end
```

A `wire` plus a `valid` bit, carried between two pieces of logic in the same cycle.
Utterly routine in Verilog — and the pairing of "the data" with "is the data real"
is a convention you maintain by hand at every use site.

## The problem

| method | behaviour |
|---|---|
| `tick` | free-running counter from 0, +1 every cycle |
| `hits` | how many pulses have occurred. A pulse is any cycle where `tick[1:0] == 0` |
| `last` | the `tick` value carried by the most recent pulse, **updated in the same cycle as the pulse**, not one later. Starts 0. |

Structure it as three rules that communicate through an `RWire`.

## Tutorial: the BSV you need

A register carries a value from one cycle to the **next**. An `RWire` carries a
value from one rule to another **within the same cycle**, and stores nothing.

```bsv
RWire #(Bit #(8)) pulse <- mkRWire;

rule produce (...);
   pulse.wset (tick_r);          // put a value on the wire this cycle
endrule

rule consume (isValid (pulse.wget));
   ...                           // read it, same cycle
endrule
```

**`wget` returns a `Maybe#(t)`** — `tagged Valid v` if some rule called `wset` this
cycle, `tagged Invalid` if none did. The data and its validity are one value; you
cannot read the data without having dealt with the validity. That is the difference
from a Verilog `wire` + `valid` pair.

Two ways to consume it:

```bsv
rule consume (isValid (pulse.wget));           // guard on validity
   last_r <= fromMaybe (0, pulse.wget);
endrule
```

```bsv
rule consume;                                  // or pattern-match
   case (pulse.wget) matches
      tagged Valid .v : begin hits_r <= hits_r + 1; last_r <= v; end
      tagged Invalid  : noAction;
   endcase
endrule
```

The guarded form is usually better: the rule genuinely should not fire when there
is nothing on the wire, and saying so lets the guard propagate (problem 07).

**`mkDWire` is the same thing with a default**, so it is never invalid:

```bsv
Wire #(Bit #(8)) w <- mkDWire (0);   // reads as 0 if nobody wrote it
w <= 42;                             // written like a register
```

Use `mkDWire` when "nothing happened" has a sensible value, and `mkRWire` when you
must distinguish "nothing happened" from "the value zero happened" — which is
exactly this problem, since `tick == 0` is a real pulse.

**Wires impose ordering.** The writer is scheduled before the reader, necessarily —
the value has to exist before it can be read. That is a constraint like any other
(problem 10), and it must be consistent with everything else.

## What changed from Verilog

- **Validity travels with the data.** `Maybe#(t)` is one value. There is no way to
  read the payload of an `Invalid` without saying what to do about it. The classic
  bug of sampling a data bus on a cycle when `valid` was low is not expressible.
- **The wire is a rule-to-rule channel, not a net.** You are not declaring
  interconnect; you are saying "this rule hands that rule a value this cycle", and
  `bsc` derives the ordering from it.
- **No state, no cycle of latency.** This is the point of the exercise: doing it
  with a register would make `last` update one cycle after `hits`, and the checker
  compares every cycle, so it would fail.
- **`mkDWire` vs `mkRWire` is a real design decision**, and BSV makes you take it
  explicitly rather than defaulting to "zero means nothing".

## How you're checked

200 cycles, 50 pulses, comparing all three outputs every cycle. Any solution that
puts a register in the pulse path fails immediately on `last`. The reference does
everything in one rule with no wires at all, which is correct and teaches nothing
about wires — read it and note that a single rule never *needs* to communicate.

## Run it

```
Run
```
