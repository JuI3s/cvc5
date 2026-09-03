; REQUIRES: cocoa
; EXPECT: sat
; COMMAND-LINE: --ff-solver=gb --ff-field-polys
; x^2 = 1 has F_3-points; 1 is not in I + <x^3 - x>
(set-info :smt-lib-version 2.6)
(set-info :category "crafted")
(set-logic QF_FF)
(declare-fun x () (_ FiniteField 3))
(assert (= (ff.mul x x) #f1m3))
(check-sat)
