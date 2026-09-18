# Progress

Updated automatically by every `Run`. `Run all` refreshes the whole table.

Status is `-` until you first run a problem, then `PASS`, `FAIL`, or `ERROR`
(a build error — read what `bsc` said).

## Ch 1 · Combinational and types

| # | Problem | Concepts | Status | Last run |
|---|---------|----------|--------|----------|
| 01 | `01_Wire_And_Not` | interfaces, value methods | `-` | — |
| 02 | `02_Mux_And_Types` | `case`, Bit/UInt/Int, Bool | `-` | — |
| 03 | `03_Adder_Widths` | width checking, zeroExtend/truncate | `-` | — |
| 04 | `04_Struct_And_Enum` | typedef, deriving, pack/unpack | `-` | — |
| 05 | `05_Vectors_And_Functions` | Vector, map/fold, static elaboration | `-` | — |

## Ch 2 · State and rules

| # | Problem | Concepts | Status | Last run |
|---|---------|----------|--------|----------|
| 06 | `06_Register_Counter` | mkReg, rule, implicit reset | `-` | — |
| 07 | `07_Rule_Guards` | a guard is not an `if` | `-` | — |
| 08 | `08_Rule_Conflicts` | conflicts, urgency, reading the schedule | `-` | — |
| 09 | `09_Shift_LFSR` | Vector of registers, replicateM | `-` | — |
| 10 | `10_CReg_Bypass` | two rules, one register, one cycle | `-` | — |
| 11 | `11_RWire_DWire` | same-cycle rule-to-rule values, Maybe | `-` | — |

## Ch 3 · Interfaces and method discipline

| # | Problem | Concepts | Status | Last run |
|---|---------|----------|--------|----------|
| 12 | `12_Action_ActionValue` | the three method kinds | `-` | — |
| 13 | `13_Implicit_Conditions` | guarded methods, backpressure | `-` | — |
| 14 | `14_Polymorphic_Module` | type parameters and provisos | `-` | — |
| 15 | `15_Typeclasses` | writing your own instances | `-` | — |

## Ch 4 · FIFOs and dataflow

| # | Problem | Concepts | Status | Last run |
|---|---------|----------|--------|----------|
| 16 | `16_FIFO_Basics` | the library FIFOs and their schedules | `-` | — |
| 17 | `17_Producer_Consumer` | rate mismatch, atomic stalling | `-` | — |
| 18 | `18_Get_Put` | Get/Put, mkConnection | `-` | — |
| 19 | `19_Pipeline_Stages` | elastic pipelines | `-` | — |
| 20 | `20_Client_Server` | request/response, multi-cycle units | `-` | — |

## Ch 5 · Sequencing, memory, verification

| # | Problem | Concepts | Status | Last run |
|---|---------|----------|--------|----------|
| 21 | `21_StmtFSM` | sequential code as a state machine | `-` | — |
| 22 | `22_Divider_FSM` | the same machine, by hand | `-` | — |
| 23 | `23_RegFile_And_BRAM` | read latency, memory as a Server | `-` | — |
| 24 | `24_Memory_Pipeline` | a pipeline around a latency | `-` | — |
| 25 | `25_Write_A_Testbench` | the flip: you write the checker | `-` | — |
