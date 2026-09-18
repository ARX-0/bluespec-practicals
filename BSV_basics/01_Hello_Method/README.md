# 01 — Hello, Method

**Concept** where BSV code goes: package, interface, module, method.

## The rule

Every BSV file is a `package` whose name matches the filename. Inside it, an
`interface` lists the ports, and a `module` implements them. A **value method**
is a piece of combinational logic: arguments in, `return` a value out.

That is the whole skeleton. Nothing here is clocked.

## Example

```bsv
package Top;
interface Const_IFC;
   method Bit #(8) answer ();
endinterface

(* synthesize *)
module mkTop (Const_IFC);
   method Bit #(8) answer ();
      return 8'd7;
   endmethod
endmodule
endpackage
```

## Your job

| method | must return |
|---|---|
| `answer()` | `8'hA5` |

Write the literal three ways if you like — `8'hA5`, `8'b1010_0101`, `8'd165` are
the same eight bits.

## Run it

```
Basics
```
