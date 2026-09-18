# 28 — case ... matches

**Concept** taking a `Maybe` apart and binding its contents in one step.

## The rule

`fromMaybe` (problem 27) is fine when you want the value or a default. When the
two cases need *different logic*, use pattern matching:

```bsv
case (m) matches
   tagged Valid .v : return v + 1;
   tagged Invalid  : return 0;
endcase
```

Note `matches` after the subject, and the **dot** in `.v`. That dot means "bind
whatever is here to a new name `v`" — `v` exists only inside that arm, and it
exists only where the value is known to be there. You cannot reach the contents
in the `Invalid` arm, because in that arm there are none.

There is a one-armed form too, usable as a condition:

```bsv
if (m matches tagged Valid .v)
   return v;
else
   return 0;
```

## Your job

| method | must return |
|---|---|
| `doubleOrZero(m)` | `2 × v` when `m` is `Valid v`, else `0` |
| `incr(m)` | `Valid (v+1)` when `m` is `Valid v`, else `Invalid` |

Both wrap at 8 bits: `doubleOrZero (Valid 200)` is 144.

## vs Verilog

`if (data_valid) out = data * 2; else out = 0;` — which compiles just as happily
without the `if`, reading a data bus that means nothing. Here the binding and the
check are the same construct, so there is no version of this code that reads the
data unguarded.

## Run it

```
Basics
```
