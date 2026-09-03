; REQUIRES: cocoa
; EXPECT: sat
; COMMAND-LINE: --ff-solver=gb
; koszul test_fq2_mul_inv_roundtrip / fq2_mul_values([2,3,1,4]) = [3,4]
(set-info :smt-lib-version 2.6)
(set-info :category "crafted")
(set-logic QF_FF)
(define-sort F () (_ FiniteField 7))
(declare-fun a0 () F)
(declare-fun a1 () F)
(declare-fun b0 () F)
(declare-fun b1 () F)
(declare-fun c0 () F)
(declare-fun c1 () F)
(assert (= a0 (as ff2 F)))
(assert (= a1 (as ff3 F)))
(assert (= b0 (as ff1 F)))
(assert (= b1 (as ff4 F)))
(assert (= c0 (ff.add (ff.mul a0 b0) (ff.mul (as ff3 F) a1 b1))))
(assert (= c1 (ff.add (ff.mul a0 b1) (ff.mul a1 b0))))
(assert (= c0 (as ff3 F)))
(assert (= c1 (as ff4 F)))
(check-sat)
