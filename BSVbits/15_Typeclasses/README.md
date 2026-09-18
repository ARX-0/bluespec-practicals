# 15 — Typeclasses: writing your own instances

**Difficulty** ▮▮▮▮▯ · **Concepts** `typeclass`, `instance`, overloading, recursive instances · **Prereq** 14

---

## The Verilog you'd write

You don't. Verilog has no overloading, so you write three differently-named
functions — `byte_score`, `card_score`, `hand_score` — and every call site picks
the right one by hand. Add a fourth type and you write a fourth function and update
every generic caller, of which there are none, because generic callers cannot exist.

## The problem

`mkTop` is already written. All three of its methods just call `score`:

```bsv
method Bit #(16) scoreByte (Bit #(8) x)          = score (x);
method Bit #(16) scoreCard (Card c)              = score (c);
method Bit #(16) scoreHand (Vector #(3, Card) h) = score (h);
```

Your job is to make `score` exist for three different types:

| instance | `score` returns |
|---|---|
| `Bit#(8)` | the value, widened to 16 bits |
| `Card` | `rank + 100 × suit`, where `Clubs`=0 … `Spades`=3 |
| `Vector#(n, t)` for **any** `n` and **any** scorable `t` | the sum of the elements' scores |

That third one is the interesting one.

## Tutorial: the BSV you need

**A typeclass declares an overloaded name.** This one is already in `Top.bsv`:

```bsv
typeclass Scorable #(type t);
   function Bit #(16) score (t x);
endtypeclass
```

It says: "`score` is a function from *some* type to `Bit#(16)`, and here is where
you say which types."

**An instance supplies the implementation for one type:**

```bsv
instance Scorable #(Bit #(8));
   function Bit #(16) score (Bit #(8) x);
      return zeroExtend (x);
   endfunction
endinstance
```

Now `score(someByte)` resolves to this. `bsc` picks the instance from the argument
type, at compile time. There is no run-time dispatch and no cost.

**Instances can be generic, with provisos.** This is the one worth learning:

```bsv
instance Scorable #(Vector #(n, t))
   provisos (Scorable #(t));
   function Bit #(16) score (Vector #(n, t) v);
      function Bit #(16) addOne (Bit #(16) acc, t e) = acc + score (e);
      return foldl (addOne, 0, v);
   endfunction
endinstance
```

Read the proviso as: "a vector is scorable **provided its elements are**." One
instance covering vectors of cards, vectors of bytes, vectors of vectors of cards —
any depth, any length, written once. The inner `score(e)` recursively resolves to
whatever instance `t` has.

**`pack` on an enum gives its number.** `pack(Clubs)` is 0, `pack(Spades)` is 3 —
declaration order, from the `deriving (Bits)` you met in problem 04. So the suit
term is `zeroExtend(pack(c.suit))`, no `case` needed.

**You have been using this since problem 04.** `deriving (Bits, Eq, FShow)` asks
`bsc` to *write* instances of `Bits`, `Eq` and `FShow` for your type. `pack`, `==`
and `fshow` are typeclass methods. This problem is the same mechanism with the
generated part done by hand.

## What changed from Verilog

- **One name, many types, resolved at compile time.** No dispatch, no tables, no
  cost — `bsc` inlines the right function.
- **Generic code becomes possible.** A module can take "any type that is `Scorable`"
  and mean it. That is what provisos on a module (problem 14) are doing: `Bits#(t,
  sz)` says "any `t` that has a `Bits` instance".
- **Instances can be conditional.** "A vector is scorable if its elements are" has
  no Verilog analogue at all. It is how `Bits`, `Eq` and `FShow` work for arbitrarily
  nested structs and vectors without anyone enumerating the combinations.
- **`deriving` stops being magic.** It is instance generation, and you can always
  write the instance yourself when the derived one is wrong.

## How you're checked

160 randomised rounds over all three instances. If an instance is missing, the
failure is a compile error at `mkTop` — `bsc` will say it cannot find a `Scorable`
instance for the type in question, which is exactly the right message.

## Run it

```
Run
```
