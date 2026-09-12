; REQUIRES: cocoa
; DISABLE-TESTER: dump
; SCRUBBER: grep -o "Symbol 'ff.pow' not declared as a variable"
; EXPECT: Symbol 'ff.pow' not declared as a variable
; EXIT: 1

; cvc5 has no compact finite-field exponentiation term. Consequently, the
; implication x^p = x => x^(p^2) = x cannot be stated without expanding the
; powers into ff.mul terms.
(set-logic QF_FF)
(define-sort F () (_ FiniteField 7))
(declare-fun x () F)
(assert (= (ff.pow x 49) x))
(check-sat)
