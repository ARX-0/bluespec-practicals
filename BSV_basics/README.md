# BSV_basics

A ladder of 42 tiny BSV problems, HDLBits-style: **one idea each, one to three
lines of answer.** It sits *below* `BSVbits/` — do this first, then that one will
read as combinations of things you already know rather than a wall of new ideas.

Concretely: `BSVbits` problem 04 asks for `typedef enum` + `typedef struct` +
`deriving` + `pack`/`unpack` + an exhaustive `case`, all at once. Here those are
problems 18, 19, 20, 21, 22, 23, 24 — and then problem **25 is BSVbits 04**, which
you reach having already written every piece of it separately.

---

## Setup — one line

```bash
export PATH="$PATH:/home/arx-0/Documents/Bluespec_practicals/BSV_basics"
```

That line is already in `~/.bashrc`. Open a new terminal, or `source ~/.bashrc` in
this one, and the `Basics` command works from anywhere.

**Without any setup**, this always works — the script finds its own ladder from
where it lives:

```bash
cd ~/Documents/Bluespec_practicals/BSV_basics/01_Hello_Method
../Basics
```

Check it is live:

```
$ Basics 01
```

You should see a FAIL. That is the untouched stub, and it confirms the checker
works before you have written anything.

`Basics` finds `bsc` and sets `BLUESPECDIR` itself; you do not need Bluespec's
environment script.

## Using it

```
Basics                  check the problem directory you are standing in
Basics 07               check problem 07, from anywhere
Basics 07_Pack_Unpack   same, by full name
Basics all              run every problem, refresh PROGRESS.md
Basics --list           the ladder with current status
Basics -v               check through generated Verilog + iverilog
Basics -w               also dump outputs/dump.vcd
Basics -c               clean build artifacts (add `all` for every problem)
Basics -h               help
```

`Basics` is this ladder; `Run` is the `BSVbits` one. They do not interfere.

## What is in a problem directory

```
20_Enum_Case/
   README.md      the one rule, an example, and what to write
   Top.bsv        >>> the file you edit <<<
   SOLUTION.md    the answer and why it is written that way
   .check/        the testbench. You never edit this
   outputs/       run.log from the last run
```

Edit `Top.bsv` only, and **do not change the interface** — the checker calls your
module through it, so a renamed method becomes a type error instead of a result.

There is no `HINTS.md`: the README already shows the syntax you need. If you are
stuck for more than a few minutes, read `SOLUTION.md` — on a ladder this granular,
being stuck means the idea has not landed yet, and the explanation is the point.

## How you are graded

Your module is driven with fixed stimulus and compared against expected values
written out in the testbench. A failure names the inputs, what was expected and
what it got. Nothing is random, so a failure is always reproducible.

| | what you see |
|---|---|
| **build error** | `bsc`'s message, verbatim — its type errors are the main teaching signal |
| **mismatch** | the first differing check, with inputs and both values |
| **stall** | `TIMEOUT … your module appears to be stalled` — a guarded method never became ready (problems 41–42) |

---

## The ladder

**Ch A · The shape of a BSV file**
| | | |
|---|---|---|
| 01 | `Hello_Method` | package, interface, module, value method |
| 02 | `Value_Method` | arguments in, result out |
| 03 | `Bit_Operators` | `&` `\|` `^` `~` |
| 04 | `Bit_Literals` | sized literals, `'1`, `0` |

**Ch B · Types**
| | | |
|---|---|---|
| 05 | `Bool_And_Bit` | `Bool` is not `Bit#(1)` |
| 06 | `UInt_And_Int` | signedness lives in the type |
| 07 | `Pack_Unpack_Basic` | `pack` / `unpack` |
| 08 | `Zero_Extend` | widths never change by themselves |
| 09 | `Sign_Extend` | the other way to widen |
| 10 | `Truncate` | `truncate`, `truncateLSB` |
| 11 | `Bit_Select_Concat` | `a[7:4]`, `a[3]`, `{x,y}` |
| 12 | `Let_And_Locals` | `let`, and when to write the type |

**Ch C · Expressions and control**
| | | |
|---|---|---|
| 13 | `Ternary_Mux` | `? :` — the condition must be a `Bool` |
| 14 | `If_Else_Method` | `if` / `else if` / `else` |
| 15 | `Case_On_Bits` | `case` as statement and as expression |
| 16 | `Case_With_Default` | when `default` is needed |
| 17 | `Functions` | naming logic once and reusing it |

**Ch D · Enums and structs** — BSVbits 04, taken apart
| | | |
|---|---|---|
| 18 | `Enum_Declare` | `typedef enum`, `deriving` |
| 19 | `Enum_Compare` | what `Eq` gave you |
| 20 | `Enum_Case` | exhaustive `case`, no `default` |
| 21 | `Struct_Construct` | `typedef struct`, building one |
| 22 | `Struct_Field_Read` | `p.field` |
| 23 | `Struct_Pack` | layout is declaration order, first field highest |
| 24 | `Struct_Unpack` | raw bits → struct, in one line |
| 25 | `Struct_Roundtrip` | **this is BSVbits problem 04** |

**Ch E · Maybe**
| | | |
|---|---|---|
| 26 | `Maybe_Construct` | `tagged Valid` / `tagged Invalid` |
| 27 | `Maybe_Query` | `isValid`, `fromMaybe` |
| 28 | `Case_Tagged` | `case (m) matches tagged Valid .v` |

**Ch F · Vector**
| | | |
|---|---|---|
| 29 | `Vector_Literal_Index` | `Vector#(n,t)`, `vec`, `v[i]` |
| 30 | `Vector_Replicate_Update` | `replicate`, `update` |
| 31 | `Vector_Map` | `map` — a row of identical logic |
| 32 | `Vector_Fold` | `fold` — a balanced tree |

**Ch G · State and rules** — where the Verilog model stops transferring
| | | |
|---|---|---|
| 33 | `First_Register` | `mkReg`, `<-`, reading a register |
| 34 | `Counter_Rule` | `rule`, and `<=` |
| 35 | `Reset_Value` | the reset value is an argument |
| 36 | `Conditional_Update` | `if` inside a rule |
| 37 | `Rule_Guard` | a guard is not an `if` |
| 38 | `Action_Method` | the second method kind |
| 39 | `ActionValue_Method` | the third, and `<-` again |
| 40 | `Two_Registers` | reads see old state, writes make new |

**Ch H · FIFO**
| | | |
|---|---|---|
| 41 | `FIFO_Enq_Deq` | `mkSizedFIFOF`, `enq` / `first` / `deq` |
| 42 | `FIFO_Guards` | implicit conditions — backpressure for free |

## Seeing the generated Verilog

Worth doing once, early:

```
Basics -v 03
less 03_Bit_Operators/outputs/verilog/mkTop.v
```

BSV compiles to ordinary RTL — the `always @(posedge CLK)` blocks and the
`EN_`/`RDY_` handshakes are all there, written for you.

## Troubleshooting

**`Basics: command not found`** — the PATH line above is not in effect in this
terminal. Open a new one, `source ~/.bashrc`, or use `../Basics` from inside a
problem directory.

**`./Basics: No such file or directory`** — `Basics` lives here, in `BSV_basics/`,
not in the problem directory. From inside a problem, that is `../Basics`.

**`Basics: not inside a problem directory`** — `cd` into one, or name it:
`Basics 07`.

**`Basics: cannot find 'bsc' on PATH`** — it looks in `~/bsc/inst/bin`,
`/opt/bsc/bin` and `/usr/local/bsc/bin`.

**A run takes ~2 seconds.** It always builds from scratch on purpose: `bsc` caches
compiled objects and only reports scheduling warnings on a compile that actually
happens.
