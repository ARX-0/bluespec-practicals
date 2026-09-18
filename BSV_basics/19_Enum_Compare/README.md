# 19 — Comparing Enum Values

**Concept** what `deriving (Eq)` bought you.

## The rule

`Eq` gives the type `==` and `!=`. Nothing else — no `<`, no arithmetic, no
comparison against a number. An enum value is compared **by name**:

```bsv
if (state == Busy) ...
Bool stopped = (light != GreenLight);
```

The result is a `Bool`, so it drops straight into `if`, `? :` and `&&`
(problem 05).

Two enum values of *different* types cannot be compared at all. That is the
protection: a `Light` can never be accidentally tested against a `Color`, or
against `2'b01`.

## Example

```bsv
method Bool isIdle (State s);
   return s == Idle;
endmethod
```

## Your job

The type is already declared in `Top.bsv`:

```bsv
typedef enum { RedLight, YellowLight, GreenLight }
   Light deriving (Bits, Eq, FShow);
```

| method | must return |
|---|---|
| `isRed(l)` | `True` when `l` is `RedLight` |
| `isGo(l)` | `True` only on `GreenLight` |
| `sameLight(a,b)` | `True` when both show the same colour |

## Run it

```
Basics
```
