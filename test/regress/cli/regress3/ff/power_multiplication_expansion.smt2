; REQUIRES: cocoa
; EXPECT: unsat
;
; Research proof of concept: known finite-field power limitation.
;
; This benchmark supports evaluation of a performance failure case. It is a
; level-3 regression under cvc5's standard runtime classification and does not
; set a time or resource limit.
;
; cvc5 has no finite-field power term, so this benchmark encodes x^p and
; x^(p^2) using named repeated squarings and ff.mul. Here p = 3329, the Kyber
; field modulus, and p^2 = 11082241. Although the source is compact, cvc5
; expands the definitions and flattens multiplication. The final power can
; therefore contain 11082241 factors in the rewritten AST.
;
; Run with cvc5's normal options:
;   cvc5 power_multiplication_expansion.smt2
; The companion regress0/ff/power_operator_unsupported.smt2 records that
; `ff.pow` cannot be used as a compact alternative.

(set-info :smt-lib-version 2.6)
(set-info :category "crafted")
(set-info :status unsat)
(set-logic QF_FF)
(define-sort F () (_ FiniteField 3329))
(declare-fun x () F)

(define-fun x2 () F (ff.mul x x))
(define-fun x4 () F (ff.mul x2 x2))
(define-fun x8 () F (ff.mul x4 x4))
(define-fun x16 () F (ff.mul x8 x8))
(define-fun x32 () F (ff.mul x16 x16))
(define-fun x64 () F (ff.mul x32 x32))
(define-fun x128 () F (ff.mul x64 x64))
(define-fun x256 () F (ff.mul x128 x128))
(define-fun x512 () F (ff.mul x256 x256))
(define-fun x1024 () F (ff.mul x512 x512))
(define-fun x2048 () F (ff.mul x1024 x1024))
(define-fun x4096 () F (ff.mul x2048 x2048))
(define-fun xp () F (ff.mul x2048 x1024 x256 x))

(define-fun x8192 () F (ff.mul x4096 x4096))
(define-fun x16384 () F (ff.mul x8192 x8192))
(define-fun x32768 () F (ff.mul x16384 x16384))
(define-fun x65536 () F (ff.mul x32768 x32768))
(define-fun x131072 () F (ff.mul x65536 x65536))
(define-fun x262144 () F (ff.mul x131072 x131072))
(define-fun x524288 () F (ff.mul x262144 x262144))
(define-fun x1048576 () F (ff.mul x524288 x524288))
(define-fun x2097152 () F (ff.mul x1048576 x1048576))
(define-fun x4194304 () F (ff.mul x2097152 x2097152))
(define-fun x8388608 () F (ff.mul x4194304 x4194304))
(define-fun xp2 () F
  (ff.mul x8388608 x2097152 x524288 x65536 x4096 x2048 x512 x))

; This conjunction is inconsistent because x^p = x implies x^(p^2) = x.
(assert (= xp x))
(assert (not (= xp2 x)))
(check-sat)
