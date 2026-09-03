; REQUIRES: cocoa
; EXPECT: unsat
; COMMAND-LINE: --ff-solver=gb
; koszul NTT §3.1 n=4 q=17: INTT(NTT(f)⊙NTT(g))=f·g
(set-info :smt-lib-version 2.6)
(set-info :category "crafted")
(set-logic QF_FF)
(define-sort F () (_ FiniteField 17))
(declare-fun psi () F)
(declare-fun f0 () F)
(declare-fun f1 () F)
(declare-fun f2 () F)
(declare-fun f3 () F)
(declare-fun g0 () F)
(declare-fun g1 () F)
(declare-fun g2 () F)
(declare-fun g3 () F)
(assert
(let ((psi2 (ff.mul psi psi)))
(let ((psi3 (ff.mul psi2 psi)))
(let ((psi4 (ff.mul psi3 psi)))
(let ((psi5 (ff.mul psi4 psi)))
(let ((psi6 (ff.mul psi5 psi)))
(let ((psi7 (ff.mul psi6 psi)))
(let ((fg0 (ff.add (ff.mul f0 g0) (ff.neg (ff.mul f1 g3)) (ff.neg (ff.mul f2 g2)) (ff.neg (ff.mul f3 g1)))) (fg1 (ff.add (ff.mul f0 g1) (ff.mul f1 g0) (ff.neg (ff.mul f2 g3)) (ff.neg (ff.mul f3 g2)))) (fg2 (ff.add (ff.mul f0 g2) (ff.mul f1 g1) (ff.mul f2 g0) (ff.neg (ff.mul f3 g3)))) (fg3 (ff.add (ff.mul f0 g3) (ff.mul f1 g2) (ff.mul f2 g1) (ff.mul f3 g0))) (nttf0 (ff.add f0 (ff.mul f1 psi) (ff.mul f2 psi2) (ff.mul f3 psi3))) (nttf1 (ff.add f0 (ff.mul f1 psi3) (ff.mul f2 psi6) (ff.mul f3 psi))) (nttf2 (ff.add f0 (ff.mul f1 psi5) (ff.mul f2 psi2) (ff.mul f3 psi7))) (nttf3 (ff.add f0 (ff.mul f1 psi7) (ff.mul f2 psi6) (ff.mul f3 psi5))) (nttg0 (ff.add g0 (ff.mul g1 psi) (ff.mul g2 psi2) (ff.mul g3 psi3))) (nttg1 (ff.add g0 (ff.mul g1 psi3) (ff.mul g2 psi6) (ff.mul g3 psi))) (nttg2 (ff.add g0 (ff.mul g1 psi5) (ff.mul g2 psi2) (ff.mul g3 psi7))) (nttg3 (ff.add g0 (ff.mul g1 psi7) (ff.mul g2 psi6) (ff.mul g3 psi5))))
 (let ((p0 (ff.mul nttf0 nttg0)) (p1 (ff.mul nttf1 nttg1)) (p2 (ff.mul nttf2 nttg2)) (p3 (ff.mul nttf3 nttg3)))
 (and (= (ff.add psi4 (as ff1 F)) (as ff0 F))
      (or (not (= (ff.mul (as ff13 F) (ff.add p0 p1 p2 p3)) fg0)) (not (= (ff.mul (as ff13 F) (ff.add (ff.mul p0 psi7) (ff.mul p1 psi5) (ff.mul p2 psi3) (ff.mul p3 psi))) fg1)) (not (= (ff.mul (as ff13 F) (ff.add (ff.mul p0 psi6) (ff.mul p1 psi2) (ff.mul p2 psi6) (ff.mul p3 psi2))) fg2)) (not (= (ff.mul (as ff13 F) (ff.add (ff.mul p0 psi5) (ff.mul p1 psi7) (ff.mul p2 psi) (ff.mul p3 psi3))) fg3)))))))))))))
(check-sat)
