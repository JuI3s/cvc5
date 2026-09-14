; REQUIRES: cocoa
; EXPECT: unsat
; EXPECT: unsat
;
; Model F_49 = F_7[alpha] / (alpha^2 - 3) using pairs (a, b) for
; a + b*alpha. The first query checks that z^7 = z characterizes the embedded
; copy of F_7 (exactly the pairs with b = 0). The second checks the Frobenius
; consequence z^7 = z => z^49 = z.

(set-info :smt-lib-version 2.6)
(set-info :category "crafted")
(set-option :incremental true)
(set-logic QF_FF)
(define-sort F () (_ FiniteField 7))

(define-fun mul-real ((ar F) (ai F) (br F) (bi F)) F
  (ff.add (ff.mul ar br) (ff.mul (as ff3 F) ai bi)))
(define-fun mul-imag ((ar F) (ai F) (br F) (bi F)) F
  (ff.add (ff.mul ar bi) (ff.mul ai br)))

(declare-fun a () F)
(declare-fun b () F)

(define-fun z2-real () F (mul-real a b a b))
(define-fun z2-imag () F (mul-imag a b a b))
(define-fun z4-real () F
  (mul-real z2-real z2-imag z2-real z2-imag))
(define-fun z4-imag () F
  (mul-imag z2-real z2-imag z2-real z2-imag))
(define-fun z6-real () F
  (mul-real z4-real z4-imag z2-real z2-imag))
(define-fun z6-imag () F
  (mul-imag z4-real z4-imag z2-real z2-imag))
(define-fun z7-real () F (mul-real z6-real z6-imag a b))
(define-fun z7-imag () F (mul-imag z6-real z6-imag a b))

(define-fun z8-real () F
  (mul-real z4-real z4-imag z4-real z4-imag))
(define-fun z8-imag () F
  (mul-imag z4-real z4-imag z4-real z4-imag))
(define-fun z16-real () F
  (mul-real z8-real z8-imag z8-real z8-imag))
(define-fun z16-imag () F
  (mul-imag z8-real z8-imag z8-real z8-imag))
(define-fun z32-real () F
  (mul-real z16-real z16-imag z16-real z16-imag))
(define-fun z32-imag () F
  (mul-imag z16-real z16-imag z16-real z16-imag))
(define-fun z48-real () F
  (mul-real z32-real z32-imag z16-real z16-imag))
(define-fun z48-imag () F
  (mul-imag z32-real z32-imag z16-real z16-imag))
(define-fun z49-real () F (mul-real z48-real z48-imag a b))
(define-fun z49-imag () F (mul-imag z48-real z48-imag a b))

(define-fun fixed-by-frobenius () Bool
  (and (= z7-real a) (= z7-imag b)))

; The F_7 subfield consists exactly of a + 0*alpha.
(push)
(assert (not (= fixed-by-frobenius (= b (as ff0 F)))))
(check-sat)
(pop)

; Refute the negation of z^7 = z => z^(7^2) = z.
(push)
(assert
  (not
    (=> fixed-by-frobenius
        (and (= z49-real a) (= z49-imag b)))))
(check-sat)
(pop)
