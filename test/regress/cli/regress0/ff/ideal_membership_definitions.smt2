; REQUIRES: cocoa
; EXPECT: unsat

; Definitions are expanded as local abbreviations. Their defining equalities
; must not become generators of the mathematical input ideal.
(set-logic QF_FF)
(define-sort F () (_ FiniteField 7))
(declare-fun x () F)
(define-fun square () F (ff.mul x x))
(check-ideal-membership (= square (as ff0 F)))
(check-sat)
