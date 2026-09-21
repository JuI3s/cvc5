; REQUIRES: cocoa
; EXPECT: false

; Run the same BN254 torus identities against the original optimized tower
; from the notes. There sigma^2 = tau, tau^3 = xi, and therefore
;
;   sigma^(q^2) = xi^((q^2-1)/6) * sigma != -sigma.
;
; The coefficient below is xi^((q^2-1)/6) for xi = 9+u and u^2 = -1.
; The failed membership check exposes that the compression formulas require
; the corrected tower rather than this representation.
(set-logic QF_FF)
(define-sort F ()
  (_ FiniteField
     21888242871839275222246405745257275088696311157297823662689037894645226208583))
(declare-fun a0 () F)
(declare-fun a1 () F)
(declare-fun sigma () F)

; Eliminate tau from sigma^2 = tau and tau^3 = xi, giving sigma^6 = xi.
; The concrete Frobenius coefficient below is computed from xi = 9+u with
; u^2 = -1, as in the BN254 tower from the notes.
(define-fun xi () F (ff.mul sigma sigma sigma sigma sigma sigma))

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

(assert (= a0-q6 a0))
(assert (= a1-q6 a1))
(assert
  (= sigma-q2
     (ff.mul
       (as ff21888242871839275220042445260109153167277707414472061641714758635765020556617
           F)
       sigma)))

(check-ideal-membership
  (=
    (ff.mul decoded-numerator f f-q2)
    (ff.mul decoded-denominator f-q6 f-q8)))
