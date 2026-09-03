; REQUIRES: cocoa
; EXPECT: unsat
; COMMAND-LINE: --ff-solver=gb --ff-field-polys
; COMMAND-LINE: --ff-solver=gb
; koszul NTT §3.3 n=2 q=17: NTT_CT = spec modulo ⟨ψ^n+1⟩
(set-info :smt-lib-version 2.6)
(set-info :category "crafted")
(set-logic QF_FF)
(define-sort F () (_ FiniteField 17))
(declare-fun psi () F)
(declare-fun f0 () F)
(declare-fun f1 () F)
(assert
(let ((psi2 (ff.mul psi psi)))
(let ((psi3 (ff.mul psi2 psi)))
(let ((ct0 (ff.add f0 (ff.mul psi f1))) (ct1 (ff.add f0 (ff.neg (ff.mul psi f1)))) (spec0 (ff.add f0 (ff.mul f1 psi))) (spec1 (ff.add f0 (ff.mul f1 psi3))))
 (and (= (ff.add psi2 (as ff1 F)) (as ff0 F))
      (or (not (= ct0 spec0)) (not (= ct1 spec1))))))))
(check-sat)
