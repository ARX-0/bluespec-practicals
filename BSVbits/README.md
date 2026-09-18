# BSVbits

HDLBits-style BSV practice: a ladder of problems, each with a teaching README, a
starter file with the interface given and the body empty, and a checker that
compares your module against a golden reference and prints PASS or FAIL.

Written for someone who already knows Verilog. Every problem README opens with the
Verilog you would have written, then shows the BSV, then names what actually changed.

---

## Setup — one line

`Run` needs to be on your PATH. Add this to the end of `~/.bashrc`:

```bash
export PATH="$PATH:/home/arx-0/Documents/Bluespec_practicals/BSVbits"
```

Then open a new terminal, or `source ~/.bashrc` in the current one.

That is the whole setup. `Run` finds `bsc` and sets `BLUESPECDIR` by itself, so you
do not need Bluespec's environment script.

Check it worked:

```
$ cd ~/Documents/Bluespec_practicals/BSVbits/01_Wire_And_Not
$ Run
```

You should see a FAIL with 16 of 32 checks passing — that is the untouched stub, and
it confirms the checker is live before you have written anything.

## Using it

```
Run                 check the problem directory you are standing in
Run 07              check problem 07, from anywhere
Run 07_Rule_Guards  same, by full name
Run all             run every problem, refresh PROGRESS.md
Run --list          the ladder with current status
Run -v              check through generated Verilog + iverilog instead of Bluesim
Run -w              also dump outputs/dump.vcd, and print the gtkwave command
Run -c              clean build artifacts (add `all` for every problem)
Run -h              help
```

**Note `Run` is not in the problem directory** — it is here, in `BSVbits/`, and works
from anywhere once it is on your PATH. There is no `./Run` to type.

## What is in a problem directory

```
07_Rule_Guards/
   README.md      the problem, the Verilog contrast, and the BSV you need
   Top.bsv        >>> the file you edit <<<
   HINTS.md       progressive nudges. Read one at a time
   SOLUTION.md    the answer and why it is written that way. Only if dire
   .check/        the golden reference and the testbench. You never edit these
   outputs/       run.log from the last run, and dump.vcd if you asked for one
```

Edit `Top.bsv` only, and **do not change the interface** — the checker instantiates
your module through it, so a renamed method becomes a type error instead of a result.

`.check/Ref.bsv` is the golden reference. It is deliberately written in a style the
problem is *not* asking for — usually explicit loops, or the very library call you
are being asked to build by hand — so it reads as a specification rather than an
answer if you look at it.

## How you are graded

Your module and the reference are instantiated side by side, driven with identical
stimulus, and compared. A failure names the cycle, the inputs, what was expected and
what it got. The stimulus seed is fixed, so a failure is reproducible.

Three ways a run can fail, and they look different:

| | what you see |
|---|---|
| **build error** | `bsc`'s message, verbatim. Its type and scheduling errors are the main teaching signal — read them |
| **mismatch** | the first differing check, with inputs and both values |
| **stall** | `TIMEOUT ... your module appears to be stalled` — a guarded method never became ready. Real, and common, from problem 13 on |

When a check fails, `Run` also prints any of `bsc`'s **scheduling warnings**
(`rule can never fire`, `treated as more urgent than`). Those are warnings, not
errors, so the build succeeded — but they very often *are* the bug. Problem 08 is
built around one.

## The ladder

Work through it in order; each problem assumes the one before.

**Ch 1 · Combinational and types**
| | | |
|---|---|---|
| 01 | `Wire_And_Not` | interfaces, value methods |
| 02 | `Mux_And_Types` | `case`, `Bit`/`UInt`/`Int`, `Bool` |
| 03 | `Adder_Widths` | width checking, `zeroExtend`/`truncate` |
| 04 | `Struct_And_Enum` | `typedef`, `deriving`, `pack`/`unpack` |
| 05 | `Vectors_And_Functions` | `Vector`, `map`/`fold`, static elaboration |

**Ch 2 · State and rules** — where the Verilog model stops transferring
| | | |
|---|---|---|
| 06 | `Register_Counter` | `mkReg`, `rule`, implicit reset |
| 07 | `Rule_Guards` | a guard is not an `if` |
| 08 | `Rule_Conflicts` | conflicts, urgency, reading the schedule |
| 09 | `Shift_LFSR` | `Vector` of registers, `replicateM` |
| 10 | `CReg_Bypass` | two rules, one register, one cycle |
| 11 | `RWire_DWire` | same-cycle rule-to-rule values, `Maybe` |

**Ch 3 · Interfaces and method discipline**
| | | |
|---|---|---|
| 12 | `Action_ActionValue` | the three method kinds |
| 13 | `Implicit_Conditions` | guarded methods; backpressure, for free |
| 14 | `Polymorphic_Module` | type parameters and provisos |
| 15 | `Typeclasses` | writing your own instances |

**Ch 4 · FIFOs and dataflow**
| | | |
|---|---|---|
| 16 | `FIFO_Basics` | the library FIFOs and their schedules |
| 17 | `Producer_Consumer` | rate mismatch, atomic stalling |
| 18 | `Get_Put` | `Get`/`Put`, `mkConnection` |
| 19 | `Pipeline_Stages` | elastic pipelines |
| 20 | `Client_Server` | request/response, multi-cycle units |

**Ch 5 · Sequencing, memory, verification**
| | | |
|---|---|---|
| 21 | `StmtFSM` | sequential code as a state machine |
| 22 | `Divider_FSM` | the same machine, by hand |
| 23 | `RegFile_And_BRAM` | read latency, and why memory is a Server |
| 24 | `Memory_Pipeline` | a pipeline around a latency |
| 25 | `Write_A_Testbench` | the flip: you write the checker |

## Seeing the generated Verilog

Worth doing at least once, early:

```
Run 01 -v
less 01_Wire_And_Not/outputs/verilog/mkTop.v
```

BSV compiles to ordinary RTL. The `always @(posedge CLK)` blocks, the reset arms and
the `EN_`/`RDY_` handshakes are all there — `bsc` wrote them so you did not have to.

## Waveforms

```
Run 09 -w
gtkwave 09_Shift_LFSR/outputs/dump.vcd
```

Off by default to keep runs fast.

## Troubleshooting

**`Run: command not found`** — the PATH line above is not in effect. Open a new
terminal or `source ~/.bashrc`.

**`./Run: No such file or directory`** — `Run` is in `BSVbits/`, not in the problem
directory. Type `Run`, not `./Run`.

**`Run: not inside a problem directory`** — you are somewhere else in the tree. Either
`cd` into a problem, or name it: `Run 07`.

**`Run: cannot find 'bsc' on PATH`** — `Run` looks in `~/bsc/inst/bin`, `/opt/bsc/bin`
and `/usr/local/bsc/bin`. If yours is elsewhere, put it on your PATH too.

**A run takes ~2 seconds.** `Run` always builds from scratch on purpose: `bsc` caches
compiled objects and only reports scheduling warnings on a compile that actually
happens, so an incremental rebuild silently drops the diagnostic that explains your
failure.
