; REQUIRES: cocoa
; EXPECT: sat
; COMMAND-LINE: --ff-solver=gb
; koszul numeric INTT(NTT(f))=f at n=4 q=17 psi=2 f=[0, 1, 2, 3]
(set-info :smt-lib-version 2.6)
(set-info :category "crafted")
(set-logic QF_FF)
(define-sort F () (_ FiniteField 17))
(declare-fun psi () F)
(declare-fun f0 () F)
(declare-fun f1 () F)
(declare-fun f2 () F)
(declare-fun f3 () F)
(assert (= psi (as ff2 F)))
(assert (= f0 (as ff0 F)))
(assert (= f1 (as ff1 F)))
(assert (= f2 (as ff2 F)))
(assert (= f3 (as ff3 F)))
(assert
(let ((psi2 (ff.mul psi psi)))
(let ((psi3 (ff.mul psi2 psi)))
(let ((psi4 (ff.mul psi3 psi)))
(let ((psi5 (ff.mul psi4 psi)))
(let ((psi6 (ff.mul psi5 psi)))
(let ((psi7 (ff.mul psi6 psi)))
(let ((ntt0 (ff.add f0 (ff.mul f1 psi) (ff.mul f2 psi2) (ff.mul f3 psi3))) (ntt1 (ff.add f0 (ff.mul f1 psi3) (ff.mul f2 psi6) (ff.mul f3 psi))) (ntt2 (ff.add f0 (ff.mul f1 psi5) (ff.mul f2 psi2) (ff.mul f3 psi7))) (ntt3 (ff.add f0 (ff.mul f1 psi7) (ff.mul f2 psi6) (ff.mul f3 psi5))))
 (and (= (ff.mul (as ff13 F) (ff.add ntt0 ntt1 ntt2 ntt3)) f0) (= (ff.mul (as ff13 F) (ff.add (ff.mul ntt0 psi7) (ff.mul ntt1 psi5) (ff.mul ntt2 psi3) (ff.mul ntt3 psi))) f1) (= (ff.mul (as ff13 F) (ff.add (ff.mul ntt0 psi6) (ff.mul ntt1 psi2) (ff.mul ntt2 psi6) (ff.mul ntt3 psi2))) f2) (= (ff.mul (as ff13 F) (ff.add (ff.mul ntt0 psi5) (ff.mul ntt1 psi7) (ff.mul ntt2 psi) (ff.mul ntt3 psi3))) f3))))))))))
(check-sat)
