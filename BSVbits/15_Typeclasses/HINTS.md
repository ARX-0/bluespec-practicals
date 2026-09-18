# Hints — 15

---

### Hint 1 — where the code goes

Between the `Card` typedef and the `Do not change anything below this line`
comment. Three `instance ... endinstance` blocks. You are not writing any module
code at all.

---

### Hint 2 — the byte instance

```bsv
instance Scorable #(Bit #(8));
   function Bit #(16) score (Bit #(8) x);
      return zeroExtend (x);
   endfunction
endinstance
```

Note the function signature inside the instance repeats the class's signature with
the type filled in.

---

### Hint 3 — the card instance

You need the suit as a number. `Suit` derives `Bits`, so `pack` gives you its
encoding — `Clubs` is 0, `Spades` is 3, in declaration order. No `case` needed:

```bsv
Bit #(16) suitNum = zeroExtend (pack (c.suit));
```

Then `rank + 100 * suitNum`, with `rank` widened to 16 bits too.

---

### Hint 4 — the vector instance

The header needs a proviso saying the element type is itself scorable:

```bsv
instance Scorable #(Vector #(n, t))
   provisos (Scorable #(t));
```

Without it, `bsc` will not let you call `score` on an element — it has no reason to
believe `t` has an instance.

---

### Hint 5 — summing the vector

`foldl` from problem 05, with a local helper that scores each element as it goes:

```bsv
function Bit #(16) addOne (Bit #(16) acc, t e) = acc + score (e);
return foldl (addOne, 0, v);
```

Define `addOne` inside the `score` function, above the `return`. The `score(e)`
call inside it resolves to the `t` instance — that is the recursion doing its work.
