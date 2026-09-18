# 19 — An elastic pipeline

**Difficulty** ▮▮▮▯▯ · **Concepts** multi-stage pipelines, elasticity, throughput vs latency · **Prereq** 18

---

## The Verilog you'd write

```verilog
always @(posedge clk) begin
   s1_data <= x + 1;         s1_valid <= in_valid;
   s2_data <= s1_data * 3;   s2_valid <= s1_valid;
   s3_data <= s2_data ^ 16'hAAAA;  s3_valid <= s2_valid;
end
```

A rigid pipeline: a `valid` bit shifted alongside the data, and no way to stall. The
moment the consumer can't take a result you must add an enable to every stage,
route it to every register, and add a skid buffer at the input so nothing is lost
in the cycle the stall is detected. That is where the bugs are.

## The problem

Three stages:

| stage | transform | widths |
|---|---|---|
| 1 | `x + 1` | `Bit#(8)` → `Bit#(8)` |
| 2 | `x * 3` | `Bit#(8)` → `Bit#(16)` |
| 3 | `x ^ 0xAAAA` | `Bit#(16)` → `Bit#(16)` |

Note stage 1 is **8-bit**, so `255 + 1` wraps to 0. The widths in the table are part
of the specification, not an accident — the reference honours them too.

Build it with **four FIFOs and three rules**. The testbench will call `put` and `get`
in the **same cycle**, 150 times in a row. If your pipeline cannot sustain that, it
stalls and the watchdog reports it.

## Tutorial: the BSV you need

Nothing new — problem 16's stage, three times:

```bsv
FIFOF #(Bit #(8))  q0 <- mkFIFOF;   // input
FIFOF #(Bit #(8))  q1 <- mkFIFOF;
FIFOF #(Bit #(16)) q2 <- mkFIFOF;
FIFOF #(Bit #(16)) q3 <- mkFIFOF;   // output

rule stage1;
   let x = q0.first;  q0.deq;  q1.enq (x + 1);
endrule
```

**What "elastic" means.** Each stage fires whenever its input FIFO is non-empty and
its output FIFO has room, independently of the others. There is no global enable and
no notion of the pipeline moving in lockstep. A stall in the middle propagates
backwards one stage per cycle as the FIFOs fill; when it clears, stages restart on
their own.

**Latency and throughput are separate.** This pipeline has a latency of 3+ cycles —
an item passes through three rules — and a throughput of one item per cycle, because
all three rules fire every cycle on different items. Those are independent
properties, and the FIFOs are what decouple them.

**Why `put` and `get` can happen in the same cycle.** `put` enqueues into `q0`, `get`
dequeues from `q3`. Different FIFOs, no conflict. Meanwhile all three stage rules
fire. Four rules and two methods, all in one cycle, on four different items — that
is a pipeline running at full rate, and you did not schedule any of it.

## What changed from Verilog

- **No `valid` bit.** Occupancy is the FIFO's business. There is no shift register of
  valids to keep aligned with the data.
- **No enable to route.** A stalled stage is a rule that does not fire, and a rule is
  atomic, so the entire stage stalls consistently. This is the single biggest source
  of Verilog pipeline bugs, and it is structurally absent.
- **No skid buffer.** The input FIFO already is one.
- **Adding or removing a stage is local.** Insert a FIFO and a rule; nothing else
  changes. In the Verilog above, inserting a stage means re-indexing the valid chain
  and re-checking every enable.
- **The cost is real, though.** Four FIFOs is more flops than four pipeline
  registers. When you know a stage can never stall, `mkPipelineFIFO` or a plain
  register is cheaper — BSV lets you choose, but the elastic default is what makes
  composition safe.

## How you're checked

The testbench fills the pipeline, then runs **150 cycles of simultaneous put and
get**, then drains. Values are compared against a reference that applies the whole
function in one method — with the same stage widths, so the wrap at 255 matches.

A non-elastic design (say, one FIFO and one rule doing all three transforms) still
produces correct values, so it will pass; that is fine. A design that cannot overlap
input and output at all will stall and trip the watchdog.

## Run it

```
Run
```

Then `Run -w` and look at the four FIFOs filling in the waveform.
