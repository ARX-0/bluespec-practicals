# Hints — 12

---

### Hint 1 — state

Two registers, both starting at 0: one for the total, one for the call count.
Name them differently from the methods (`total_r`, `count_r`).

---

### Hint 2 — add

An `Action` method body is just a list of actions, exactly like a rule body:

```bsv
method Action add (Bit #(8) x);
   total_r <= total_r + x;
   count_r <= count_r + 1;
endmethod
```

Delete the `noAction` placeholder — it was only there so the stub compiled.

---

### Hint 3 — takeAndClear

The trick is that you do not need a trick. Write the clear and the return in the
obvious order:

```bsv
total_r <= 0;
return total_r;
```

`<=` is non-blocking, so `total_r` in the `return` is still the old value. The
write lands at the clock edge, after the read.

---

### Hint 4 — count is not reset

`takeAndClear` clears the total only. Do not touch `count_r` in it.

---

### Hint 5 — the value methods

```bsv
method Bit #(8) total () = total_r;
```
