; REQUIRES: cocoa
; EXPECT: unsat
; COMMAND-LINE: --ff-solver=gb
; koszul NTT §3.3 n=4 q=17: NTT_CT = spec modulo ⟨ψ^n+1⟩
(set-info :smt-lib-version 2.6)
(set-info :category "crafted")
(set-logic QF_FF)
(define-sort F () (_ FiniteField 17))
(declare-fun psi () F)
(declare-fun f0 () F)
(declare-fun f1 () F)
(declare-fun f2 () F)
(declare-fun f3 () F)
(assert
(let ((psi2 (ff.mul psi psi)))
(let ((psi3 (ff.mul psi2 psi)))
(let ((psi4 (ff.mul psi3 psi)))
(let ((psi5 (ff.mul psi4 psi)))
(let ((psi6 (ff.mul psi5 psi)))
(let ((psi7 (ff.mul psi6 psi)))
(let ((ct0 (ff.add (ff.add f0 (ff.mul psi2 f2)) (ff.mul psi (ff.add f1 (ff.mul psi2 f3))))) (ct1 (ff.add (ff.add f0 (ff.neg (ff.mul psi2 f2))) (ff.mul psi3 (ff.add f1 (ff.neg (ff.mul psi2 f3)))))) (ct2 (ff.add (ff.add f0 (ff.mul psi2 f2)) (ff.neg (ff.mul psi (ff.add f1 (ff.mul psi2 f3)))))) (ct3 (ff.add (ff.add f0 (ff.neg (ff.mul psi2 f2))) (ff.neg (ff.mul psi3 (ff.add f1 (ff.neg (ff.mul psi2 f3))))))) (spec0 (ff.add f0 (ff.mul f1 psi) (ff.mul f2 psi2) (ff.mul f3 psi3))) (spec1 (ff.add f0 (ff.mul f1 psi3) (ff.mul f2 psi6) (ff.mul f3 psi))) (spec2 (ff.add f0 (ff.mul f1 psi5) (ff.mul f2 psi2) (ff.mul f3 psi7))) (spec3 (ff.add f0 (ff.mul f1 psi7) (ff.mul f2 psi6) (ff.mul f3 psi5))))
 (and (= (ff.add psi4 (as ff1 F)) (as ff0 F))
      (or (not (= ct0 spec0)) (not (= ct1 spec1)) (not (= ct2 spec2)) (not (= ct3 spec3))))))))))))
(check-sat)
