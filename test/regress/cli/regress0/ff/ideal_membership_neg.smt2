; REQUIRES: cocoa
; EXPECT: sat

; The ideal-membership encoder supports subtraction through ff.neg.
(set-logic QF_FF)
(define-sort F () (_ FiniteField 7))
(declare-fun x () F)
(declare-fun y () F)
(assert (= (ff.add x (ff.neg y)) (as ff0 F)))
(check-ideal-membership (= x y))
(check-sat)
