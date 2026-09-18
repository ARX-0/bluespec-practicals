# 21 — StmtFSM: sequential code that compiles to a state machine

**Difficulty** ▮▮▮▯▯ · **Concepts** `Stmt`, `seq`/`par`/`while`, `mkFSM` vs `mkAutoFSM` · **Prereq** 20

---

## The Verilog you'd write

```verilog
localparam IDLE = 2'd0, LOOP = 2'd1, DONE = 2'd2;
always @(posedge clk) case (state)
   IDLE: if (start) begin acc <= 0; i <= 0; state <= LOOP; end
   LOOP: if (i < n) begin acc <= acc + i; i <= i + 1; end
         else state <= DONE;
   DONE: begin result <= acc; state <= IDLE; end
endcase
```

A state enum, a `case`, and transitions written by hand. The *algorithm* — "zero the
accumulator, then loop, then output" — is in there, spread across three arms and
reconstructed by the reader.

## The problem

| method | behaviour |
|---|---|
| `start(n)` | begin summing 0 + 1 + … + (n−1). Guarded: only when idle |
| `busy()` | is a computation in progress? |
| `result()` | the finished sum. Guarded |

`start(0)` and `start(1)` both give 0.

## Tutorial: the BSV you need

**A `Stmt` is a description of a sequence.** It is data, not hardware, until you hand
it to a module:

```bsv
Stmt prog =
   seq
      action
         acc <= 0;
         i   <= 0;
      endaction
      while (i < n_r) seq
         action
            acc <= acc + zeroExtend (i);
            i   <= i + 1;
         endaction
      endseq
      outQ.enq (acc);
   endseq;

FSM fsm <- mkFSM (prog);
```

`bsc` compiles that into the state register, the `case` and the transitions.

**One `action` block = one clock cycle.** That is the rule to hold onto. Statements
in a `seq` happen in successive cycles; everything inside a single `action` happens
in the same cycle, atomically, like a rule body.

**The constructs:**

| | |
|---|---|
| `seq … endseq` | one after another, a cycle each |
| `par … endpar` | all at once, in parallel; finishes when the slowest does |
| `while (c) …` | loop, testing each time round |
| `if (c) … else …` | branch |
| `repeat (n) …` | fixed count |
| `await (c)` | stall here until `c` is true |

**`mkFSM` vs `mkAutoFSM`.** `mkFSM(prog)` gives you an `FSM` interface you drive:

```bsv
fsm.start;     // Action: begin (guarded on being done)
fsm.done       // Bool
```

`mkAutoFSM(prog)` starts by itself and **calls `$finish` when it completes**. That is
right for a top-level testbench — every checker in this course uses it — and wrong
for anything else, because `$finish` ends the entire simulation.

**The FSM coexists with rules.** It is just rules underneath. Registers it touches are
ordinary registers, and the guards in this problem (`start` when `fsm.done`) work as
usual.

## What changed from Verilog

- **The algorithm reads as the algorithm.** The loop is a `while` loop. There is no
  state enum to name, no transitions to get wrong, and adding a step in the middle
  does not renumber anything.
- **The state encoding is the compiler's problem.** No `localparam`s, no risk of two
  states colliding, no unreachable arm.
- **Cycle boundaries are explicit and visible.** Each `action` is one cycle. In the
  Verilog you infer the timing from the structure of the `case`.
- **It is not a replacement for rules.** `seq` imposes a fixed order, which is exactly
  what you do *not* want when reacting to things arriving from outside at
  unpredictable times. Problem 22 is the same machine written with guarded rules, and
  it is the right tool the moment the sequence must be interruptible or elastic.

## How you're checked

40 summations, with n = 0 and n = 1 forced first (the two cases where the loop body
never runs or runs once). The reference uses the closed form n(n−1)/2 in a single
cycle — it defines the answer and says nothing about how to iterate.

The testbench blocks on `result()`, so an FSM that never finishes trips the watchdog.

## Run it

```
Run
```
