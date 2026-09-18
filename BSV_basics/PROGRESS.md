# Progress

Updated automatically by every `Basics`. `Basics all` refreshes the whole table.

Status is `-` until you first run a problem, then `PASS`, `FAIL`, or `ERROR`
(a build error — read what `bsc` said).

## Ch A · The shape of a BSV file

| # | Problem | Concepts | Status | Last run |
|---|---------|----------|--------|----------|
| 01 | `01_Hello_Method` | package, interface, module, value method | `-` | — |
| 02 | `02_Value_Method` | arguments in, result out | `-` | — |
| 03 | `03_Bit_Operators` | & \| ^ ~ | `-` | — |
| 04 | `04_Bit_Literals` | sized literals, '1, 0 | `-` | — |

## Ch B · Types

| # | Problem | Concepts | Status | Last run |
|---|---------|----------|--------|----------|
| 05 | `05_Bool_And_Bit` | Bool is not Bit#(1) | `-` | — |
| 06 | `06_UInt_And_Int` | signedness lives in the type | `-` | — |
| 07 | `07_Pack_Unpack_Basic` | pack / unpack | `-` | — |
| 08 | `08_Zero_Extend` | widths never change by themselves | `-` | — |
| 09 | `09_Sign_Extend` | the other way to widen | `-` | — |
| 10 | `10_Truncate` | truncate, truncateLSB | `-` | — |
| 11 | `11_Bit_Select_Concat` | a[7:4], a[3], {x,y} | `-` | — |
| 12 | `12_Let_And_Locals` | let, and when to write the type | `-` | — |

## Ch C · Expressions and control

| # | Problem | Concepts | Status | Last run |
|---|---------|----------|--------|----------|
| 13 | `13_Ternary_Mux` | ? : with a Bool condition | `-` | — |
| 14 | `14_If_Else_Method` | if / else if / else | `-` | — |
| 15 | `15_Case_On_Bits` | case as statement and expression | `-` | — |
| 16 | `16_Case_With_Default` | when default is needed | `-` | — |
| 17 | `17_Functions` | naming logic once and reusing it | `-` | — |

## Ch D · Enums and structs

| # | Problem | Concepts | Status | Last run |
|---|---------|----------|--------|----------|
| 18 | `18_Enum_Declare` | typedef enum, deriving | `-` | — |
| 19 | `19_Enum_Compare` | what Eq gave you | `-` | — |
| 20 | `20_Enum_Case` | exhaustive case, no default | `-` | — |
| 21 | `21_Struct_Construct` | typedef struct, building one | `-` | — |
| 22 | `22_Struct_Field_Read` | p.field | `-` | — |
| 23 | `23_Struct_Pack` | layout is declaration order | `-` | — |
| 24 | `24_Struct_Unpack` | raw bits to struct, one line | `-` | — |
| 25 | `25_Struct_Roundtrip` | this is BSVbits problem 04 | `-` | — |

## Ch E · Maybe

| # | Problem | Concepts | Status | Last run |
|---|---------|----------|--------|----------|
| 26 | `26_Maybe_Construct` | tagged Valid / tagged Invalid | `-` | — |
| 27 | `27_Maybe_Query` | isValid, fromMaybe | `-` | — |
| 28 | `28_Case_Tagged` | case ... matches tagged Valid .v | `-` | — |

## Ch F · Vector

| # | Problem | Concepts | Status | Last run |
|---|---------|----------|--------|----------|
| 29 | `29_Vector_Literal_Index` | Vector#(n,t), vec, v[i] | `-` | — |
| 30 | `30_Vector_Replicate_Update` | replicate, update | `-` | — |
| 31 | `31_Vector_Map` | map, a row of identical logic | `-` | — |
| 32 | `32_Vector_Fold` | fold, a balanced tree | `-` | — |

## Ch G · State and rules

| # | Problem | Concepts | Status | Last run |
|---|---------|----------|--------|----------|
| 33 | `33_First_Register` | mkReg, <-, reading a register | `-` | — |
| 34 | `34_Counter_Rule` | rule, and <= | `-` | — |
| 35 | `35_Reset_Value` | the reset value is an argument | `-` | — |
| 36 | `36_Conditional_Update` | if inside a rule | `-` | — |
| 37 | `37_Rule_Guard` | a guard is not an if | `-` | — |
| 38 | `38_Action_Method` | the second method kind | `-` | — |
| 39 | `39_ActionValue_Method` | the third, and <- again | `-` | — |
| 40 | `40_Two_Registers` | reads see old state, writes make new | `-` | — |

## Ch H · FIFO

| # | Problem | Concepts | Status | Last run |
|---|---------|----------|--------|----------|
| 41 | `41_FIFO_Enq_Deq` | mkSizedFIFOF, enq / first / deq | `-` | — |
| 42 | `42_FIFO_Guards` | implicit conditions, backpressure | `-` | — |

---

When every row here reads `PASS`, go to `BSVbits/` and start at 01.
