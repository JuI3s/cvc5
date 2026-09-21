; REQUIRES: cocoa
; EXPECT: true

; End-to-end scalar obligation for BN254 torus compression using the corrected
; tower from the notes, where sigma^2 = xi and sigma^(q^2) = -sigma. Start with
;
;   f = a0 + a1*sigma,       alpha = a0/a1,
;
; derive alpha^(q^2) = a0^(q^2)/a1^(q^2), compress and decompress alpha,
; and compare the result directly with f^Psi_6(q^2), where
;
;   Psi_6(q^2) = (q^6 - 1)(q^2 + 1).
;
; All divisions are cross-multiplied. The target does not prove denominator
; nonvanishing; the rational statement is
; conditional on the compression, decompression, and alpha denominators.
(set-logic QF_FF)
(define-sort F ()
  (_ FiniteField
     21888242871839275222246405745257275088696311157297823662689037894645226208583))
(declare-fun a0 () F)
(declare-fun a1 () F)
(declare-fun sigma () F)

; The compression-friendly quadratic tower defines xi = sigma^2. Substituting
; it here keeps the E2E query on the exact tower and leaves only independent
; power-difference generators for the membership check.
(define-fun xi () F (ff.mul sigma sigma))

; Derive q^2, q^6, and q^8 by composing the single q-power operation. This
; avoids independent decimal literals for powers of the BN254 modulus.
(define-fun q-frob ((x F)) F
  ((_ ff.pow
      21888242871839275222246405745257275088696311157297823662689037894645226208583)
    x))
(define-fun q2-frob ((x F)) F (q-frob (q-frob x)))
(define-fun q6-frob ((x F)) F
  (q2-frob (q2-frob (q2-frob x))))
(define-fun q8-frob ((x F)) F (q2-frob (q6-frob x)))

(define-fun a0-q2 () F (q2-frob a0))
(define-fun a1-q2 () F (q2-frob a1))
(define-fun sigma-q2 () F (q2-frob sigma))
(define-fun a0-q6 () F (q6-frob a0))
(define-fun a1-q6 () F (q6-frob a1))
(define-fun sigma-q6 () F (q6-frob sigma))
(define-fun a0-q8 () F (q8-frob a0))
(define-fun a1-q8 () F (q8-frob a1))
(define-fun sigma-q8 () F (q8-frob sigma))

(define-fun f () F (ff.add a0 (ff.mul a1 sigma)))
(define-fun f-q2 () F (ff.add a0-q2 (ff.mul a1-q2 sigma-q2)))
(define-fun f-q6 () F (ff.add a0-q6 (ff.mul a1-q6 sigma-q6)))
(define-fun f-q8 () F (ff.add a0-q8 (ff.mul a1-q8 sigma-q8)))

; Numerators after alpha=a0/a1 and alpha^(q^2)=a0^(q^2)/a1^(q^2).
(define-fun alpha-difference () F
  (ff.add (ff.mul a0 a1-q2) (ff.neg (ff.mul a0-q2 a1))))
(define-fun compression-numerator () F
  (ff.add
    (ff.mul xi a1 a1-q2)
    (ff.neg (ff.mul a0 a0-q2))))
(define-fun decoded-numerator () F
  (ff.add
    compression-numerator
    (ff.neg (ff.mul sigma alpha-difference))))
(define-fun decoded-denominator () F
  (ff.add compression-numerator (ff.mul sigma alpha-difference)))

; a0 and a1 model F_(q^6) elements, while sigma is the quadratic generator.
(assert (= a0-q6 a0))
(assert (= a1-q6 a1))
(assert (= sigma-q2 (ff.neg sigma)))

; (decoded-numerator/decoded-denominator)
;   = (f-q6*f-q8)/(f*f-q2) = f^Psi_6(q^2).
(check-ideal-membership
  (=
    (ff.mul decoded-numerator f f-q2)
    (ff.mul decoded-denominator f-q6 f-q8)))
