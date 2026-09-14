; REQUIRES: cocoa
; EXPECT: unknown

; The default mixed strategy is sound but incomplete. It does not claim false
; when membership requires combining a power rule with a generic generator.
(set-logic QF_FF)
(define-sort F () (_ FiniteField 7))
(declare-fun x () F)
(declare-fun y () F)
(assert (= (ff.mul x x) (as ff1 F)))
(assert (= (ff.mul x y) (as ff0 F)))
(check-ideal-membership (= y (as ff0 F)))
