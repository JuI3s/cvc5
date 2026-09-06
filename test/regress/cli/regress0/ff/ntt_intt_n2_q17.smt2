; REQUIRES: cocoa
; EXPECT: unsat
; COMMAND-LINE: --ff-solver=gb --ff-field-polys
; COMMAND-LINE: --ff-solver=gb
; koszul NTT §3.2.1 n=2 q=17: INTT(NTT(f))=f in ⟨ψ^n+1⟩
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
(let ((ntt0 (ff.add f0 (ff.mul f1 psi))) (ntt1 (ff.add f0 (ff.mul f1 psi3))))
 (and (= (ff.add psi2 (as ff1 F)) (as ff0 F))
      (or (not (= (ff.mul (as ff9 F) (ff.add ntt0 ntt1)) f0)) (not (= (ff.mul (as ff9 F) (ff.add (ff.mul ntt0 psi3) (ff.mul ntt1 psi))) f1))))))))
(check-sat)
