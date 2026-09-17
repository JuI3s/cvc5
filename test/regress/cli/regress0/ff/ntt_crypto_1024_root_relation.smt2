; REQUIRES: cocoa
; EXPECT: unsat
; COMMAND-LINE: --ff-solver=gb
; koszul root relation: ψ^1024=-1 ⊢ ψ^2048=1 over F_2013265921
(set-info :smt-lib-version 2.6)
(set-info :category "crafted")
(set-logic QF_FF)
(define-sort F () (_ FiniteField 2013265921))
(declare-fun psi () F)
(assert
(let ((p2 (ff.mul psi psi)))
 (let ((p4 (ff.mul p2 p2)))
 (let ((p8 (ff.mul p4 p4)))
 (let ((p16 (ff.mul p8 p8)))
 (let ((p32 (ff.mul p16 p16)))
 (let ((p64 (ff.mul p32 p32)))
 (let ((p128 (ff.mul p64 p64)))
 (let ((p256 (ff.mul p128 p128)))
 (let ((p512 (ff.mul p256 p256)))
 (let ((p1024 (ff.mul p512 p512)))
 (let ((p2048 (ff.mul p1024 p1024)))
 (and (= p1024 (as ff2013265920 F)) (not (= p2048 (as ff1 F))))))))))))))))
(check-sat)
