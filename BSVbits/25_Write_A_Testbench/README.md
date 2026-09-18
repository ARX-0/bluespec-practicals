# 25 — Write the testbench

**Difficulty** ▮▮▮▮▮ · **Concepts** verification, coverage, exhaustive testing, `mkFSM` vs `mkAutoFSM` · **Prereq** 24

---

> The last problem inverts the course. Every problem so far handed you a checker.
> This one asks you to *be* the checker — and grades your testbench, not a design.

## The problem

You are given a module to test:

```bsv
interface AbsDiff_IFC;
   method Bit #(8) absdiff (Bit #(8) a, Bit #(8) b);
endinterface
```

`absdiff(a, b)` is `|a − b|` with `a` and `b` **unsigned** 0..255.
`absdiff(3, 10) == 7`. `absdiff(10, 3) == 7`. `absdiff(5, 5) == 0`.

Write `mkTester`, which is handed one of these modules and must decide whether it is
correct:

```bsv
interface Tester_IFC;
   method Bool done ();     // finished testing
   method Bool passed ();   // the verdict, once done
endinterface
```

**Your tester is then run four times:**

| against | it must |
|---|---|
| one **correct** module | **accept** it |
| three **broken** modules | **reject** all three |

A tester that says `passed = True` without testing anything accepts the correct
module — and all three broken ones. That is the stub you start with, and it fails 3
of 4.

## The lesson

**One of the three broken modules is wrong for exactly one input pair out of 65536.**

Random sampling will not find it. A few hundred or a few thousand random vectors will
catch the other two bugs, feel thorough, and miss this one entirely — which is
precisely the experience this problem exists to give you.

The input space here is 256 × 256 = 65536 pairs. That is nothing for a simulator: a
few milliseconds. **When the space is small enough to cover exhaustively, cover it
exhaustively.** The judgement being trained is recognising when that is possible.

## Tutorial: the BSV you need

Nothing new. Two things to get right:

**1. Do not use `mkAutoFSM`.** It starts by itself and calls `$finish` when its
sequence completes — which would end the *entire* simulation, including the other
three testers running alongside yours. Use `mkFSM` and start it from a rule:

```bsv
FSM fsm <- mkFSM (prog);

Reg #(Bool) started <- mkReg (False);
rule kick (! started);
   fsm.start;
   started <= True;
endrule
```

Or skip `StmtFSM` entirely and write a plain rule with your own counters — for a
double loop either is fine.

**2. Loop counters need a bit of headroom.** To iterate `a` over 0..255 the counter
must be able to *reach* 256 to terminate, so it is `Bit#(9)`, and you `truncate` it
when passing it to the DUT. A `Bit#(8)` counter with `while (a < 256)` never
terminates — the comparison is always true — and the watchdog will report a stall.

**Computing the expected value.** Write it independently of how you imagine the DUT
works:

```bsv
Bit #(8) exp = (x >= y) ? (x - y) : (y - x);
```

## What this is really teaching

- **A testbench that only passes correct designs is worthless.** Its job is to *fail*
  broken ones. When you write one, ask what bug it would catch — and if the answer is
  "none that I can think of", it is not a test.
- **Coverage is a property of the stimulus, not of the effort.** 2000 random vectors
  feels more thorough than 256 careful ones and is often less.
- **Corner cases are where bugs live**: equal inputs, zero, maximum, the boundary
  between two branches. Two of the three bugs here sit exactly on such a case.
- **Exhaustive testing is underrated.** Designers reach for randomisation by habit.
  For an 8-bit-by-8-bit combinational function, exhaustive is both cheaper and total.

## How you're checked

Your `mkTester` is instantiated four times, once per module. The checker waits for all
four to report `done`, then grades the four verdicts. Each failure names which module
you got wrong and why it was broken.

An exhaustive tester takes about 65000 cycles — the run takes a second or two longer
than the others. That is expected.

## Run it

```
Run
```

`.check/Duts.bsv` holds the four modules. Reading it turns "write a thorough
testbench" into "write a testbench targeting these three bugs", which is the opposite
of the exercise. Look afterwards.
