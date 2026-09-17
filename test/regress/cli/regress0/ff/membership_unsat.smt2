; REQUIRES: cocoa
; EXPECT: unsat
; COMMAND-LINE: --ff-solver=gb --ff-field-polys
; x^2 = 2 has no F_3-point; 1 is in I + <x^3 - x>
(set-info :smt-lib-version 2.6)
(set-info :category "crafted")
(set-logic QF_FF)
(declare-fun x () (_ FiniteField 3))
(assert (= (ff.mul x x) #f2m3))
(check-sat)
