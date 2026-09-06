; REQUIRES: cocoa
; EXPECT: unsat
; COMMAND-LINE: --ff-solver=gb --ff-field-polys
; COMMAND-LINE: --ff-solver=gb
; koszul NTT §3.1 n=2 q=17: INTT(NTT(f)⊙NTT(g))=f·g
(set-info :smt-lib-version 2.6)
(set-info :category "crafted")
(set-logic QF_FF)
(define-sort F () (_ FiniteField 17))
(declare-fun psi () F)
(declare-fun f0 () F)
(declare-fun f1 () F)
(declare-fun g0 () F)
(declare-fun g1 () F)
(assert
(let ((psi2 (ff.mul psi psi)))
(let ((psi3 (ff.mul psi2 psi)))
(let ((fg0 (ff.add (ff.mul f0 g0) (ff.neg (ff.mul f1 g1)))) (fg1 (ff.add (ff.mul f0 g1) (ff.mul f1 g0))) (nttf0 (ff.add f0 (ff.mul f1 psi))) (nttf1 (ff.add f0 (ff.mul f1 psi3))) (nttg0 (ff.add g0 (ff.mul g1 psi))) (nttg1 (ff.add g0 (ff.mul g1 psi3))))
 (let ((p0 (ff.mul nttf0 nttg0)) (p1 (ff.mul nttf1 nttg1)))
 (and (= (ff.add psi2 (as ff1 F)) (as ff0 F))
      (or (not (= (ff.mul (as ff9 F) (ff.add p0 p1)) fg0)) (not (= (ff.mul (as ff9 F) (ff.add (ff.mul p0 psi3) (ff.mul p1 psi))) fg1)))))))))
(check-sat)
