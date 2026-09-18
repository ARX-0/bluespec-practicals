# Solution — 25

Only if dire.

---

```bsv
   Reg #(Bit #(9)) a       <- mkReg (0);
   Reg #(Bit #(9)) b       <- mkReg (0);
   Reg #(Bool)     ok      <- mkReg (True);
   Reg #(Bool)     fin     <- mkReg (False);
   Reg #(Bool)     started <- mkReg (False);

   Stmt prog =
      seq
         while (a < 256) seq
            action b <= 0; endaction
            while (b < 256) seq
               action
                  Bit #(8) x   = truncate (a);
                  Bit #(8) y   = truncate (b);
                  Bit #(8) got = dut.absdiff (x, y);
                  Bit #(8) exp = (x >= y) ? (x - y) : (y - x);
                  if (got != exp)
                     ok <= False;
                  b <= b + 1;
               endaction
            endseq
            action a <= a + 1; endaction
         endseq
         action fin <= True; endaction
      endseq;

   FSM fsm <- mkFSM (prog);

   rule kick (! started);
      fsm.start;
      started <= True;
   endrule

   method Bool done ()   = fin;
   method Bool passed () = ok;
```

## Why it is written this way

**Exhaustive, because it can be.** 65536 pairs, one per cycle, is under a millisecond
of simulation. Against that, any sampling strategy is strictly worse: it costs more
thought, gives a weaker guarantee, and — as the three bugs are designed to show —
misses things.

The judgement worth taking away is not "always be exhaustive". It is: **work out how
big the input space is before you decide how to test it.** An 8×8-bit combinational
function is 2¹⁶ and trivially exhaustible. A 32×32-bit one is 2⁶⁴ and not, so there
you need directed corner cases plus randomisation plus reasoning. Designers routinely
reach for constrained-random on problems small enough to have simply finished.

**The three bugs, and what each one punishes:**

| bug | wrong when | caught by |
|---|---|---|
| 1: returns `a - b` | `b > a` — roughly half of all inputs | almost any test |
| 2: returns 1 when `a == b` | 256 of 65536 pairs | a few thousand random vectors, or a deliberate equal-inputs case |
| 3: wrong at `(0, 255)` only | **1 of 65536** | exhaustive testing, or a deliberate extremes case |

Bug 2 is the one that makes randomisation *look* adequate — it turns up soon enough
to build false confidence. Bug 3 is the one that punishes it. That ordering is
deliberate.

**`ok <= False` and never back to True.** A verdict register must be sticky. Setting
`ok <= (got == exp)` each iteration would report only the result of the *last*
comparison, which passes for every one of the four modules, including all three broken
ones.

**`Bit#(9)` counters.** The loop terminates when `a` reaches 256, which an 8-bit
register cannot represent — `a < 256` would be a tautology and the FSM would run
forever. The watchdog turns that into a legible timeout rather than a hang, but the
fix is the extra bit. Off-by-one on a loop bound is the most common bug in
hand-written testbenches, in any language.

**`mkFSM` with a `kick` rule, not `mkAutoFSM`.** Four copies of your tester run
concurrently. `mkAutoFSM` calls `$finish` when its sequence ends, so the first tester
to complete would terminate the simulation and the other three would never report.
`$finish` is a global action, and this is the standard way to get burned by it.

**The expected value is computed from the specification.** `(x >= y) ? (x - y) : (y - x)`
is derived from what `absdiff` is *supposed* to do. A tester that computed the expected
value the way it imagined the DUT was implemented would reproduce the DUT's bugs and
pass everything.

## What to take forward

You have now written both halves: designs that get checked, and the checker that does
it. Some things worth keeping:

- **A test's value is measured in bugs it would catch**, not in lines or in vectors
  run. Before writing one, name a bug it is for.
- **Size the input space first.** Exhaustive when you can, directed corners plus
  randomisation when you cannot.
- **Corner cases are where the bugs are**: zero, maximum, equal operands, the exact
  boundary between two branches of a conditional, the carry out of the top bit.
- **Verdict state must be sticky**, and loop bounds need headroom.
- **`$finish` is global.** In a testbench with more than one thing running, only the
  top level may call it.

---

## That is the end of the ladder

You have covered the whole of BSV's core: types and static elaboration, atomic
guarded rules and the scheduler, the three ways rules share state, method discipline
and implicit conditions, polymorphism and typeclasses, FIFOs and elastic dataflow,
`Get`/`Put`/`Client`/`Server`, sequencing, memory latency, and verification.

Everything past this point is composition. A RISC-V core is problems 06–11 and 22–24
arranged around an instruction; an AXI4 fabric is problems 04, 13, 18 and 20 arranged
around five channels. There is no further mechanism to learn — only larger things to
build out of these.
