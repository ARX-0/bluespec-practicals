# 36 — if inside a Rule

**Concept** choosing *what* a rule writes, as opposed to *whether* it fires.

## The rule

A rule body can contain `if`:

```bsv
rule tick;
   if (r == 9)
      r <= 0;
   else
      r <= r + 1;
endrule
```

The rule fires **every cycle either way**. The `if` only selects which value gets
written — it is a multiplexer in front of the register's input, exactly as an `if`
inside a Verilog `always` block would be.

The equivalent one-liner is often clearer:

```bsv
r <= (r == 9) ? 0 : r + 1;
```

Both describe the same hardware. Use whichever reads better.

**A register may be written at most once per rule.** Two `r <= ...` statements on
different branches of an `if` is fine — only one branch runs. Two on the *same*
path is an error, and a useful one.

## Your job

| method | must return |
|---|---|
| `count()` | 0, 1, 2, … 9, 0, 1, … — never 10 |

## What comes next

Problem 37 does something that *looks* the same and is not: putting the condition
on the rule itself, so the rule does not fire at all. Get this one working first,
then compare them.

## Run it

```
Basics
```
