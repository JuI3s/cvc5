; REQUIRES: cocoa
; EXPECT: false

; This checks literal ideal membership, not finite-field entailment. Although
; x^2 = 0 implies x = 0 over a field, x is not an element of <x^2>.
(set-logic QF_FF)
(define-sort F () (_ FiniteField 7))
(declare-fun x () F)
(assert (= (ff.mul x x) (as ff0 F)))
(check-ideal-membership (= x (as ff0 F)))
