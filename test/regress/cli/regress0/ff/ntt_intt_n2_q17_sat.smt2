; REQUIRES: cocoa
; EXPECT: sat
; COMMAND-LINE: --ff-solver=gb
; koszul numeric INTT(NTT(f))=f at n=2 q=17 psi=4 f=[0, 1]
(set-info :smt-lib-version 2.6)
(set-info :category "crafted")
(set-logic QF_FF)
(define-sort F () (_ FiniteField 17))
(declare-fun psi () F)
(declare-fun f0 () F)
(declare-fun f1 () F)
(assert (= psi (as ff4 F)))
(assert (= f0 (as ff0 F)))
(assert (= f1 (as ff1 F)))
(assert
(let ((psi2 (ff.mul psi psi)))
(let ((psi3 (ff.mul psi2 psi)))
(let ((ntt0 (ff.add f0 (ff.mul f1 psi))) (ntt1 (ff.add f0 (ff.mul f1 psi3))))
 (and (= (ff.mul (as ff9 F) (ff.add ntt0 ntt1)) f0) (= (ff.mul (as ff9 F) (ff.add (ff.mul ntt0 psi3) (ff.mul ntt1 psi))) f1))))))
(check-sat)
