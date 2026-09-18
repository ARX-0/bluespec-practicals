// ============================================================================
// Stim.bsv -- deterministic pseudo-random stimulus shared by the testbenches.
//
// Deliberately NOT a module: `nextRand` is a pure function, so the same seed
// always produces the same test sequence. A failing run is always reproducible,
// and the mismatch you see is the mismatch you will see again after you edit.
// ============================================================================

package Stim;

// 32-bit xorshift. Cheap, and good enough to shake out logic bugs.
function Bit #(32) nextRand (Bit #(32) s);
   Bit #(32) x = s;
   x = x ^ (x << 13);
   x = x ^ (x >> 17);
   x = x ^ (x << 5);
   return x;
endfunction

// A seed that is never zero (xorshift is stuck at zero).
function Bit #(32) seedFrom (Bit #(32) k) = (k == 0) ? 32'h1357_9BDF : k;

endpackage
