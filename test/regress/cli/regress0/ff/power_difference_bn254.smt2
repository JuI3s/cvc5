; REQUIRES: cocoa
; COMMAND-LINE: --ff-solver=gb
; COMMAND-LINE: --ff-solver=split
; EXPECT: unsat

; BN254 base-field prime q. The finite-field solver checks the disequality
; polynomial directly against <x^q - x>. Power-difference reduction maps
; x^(q^2) - x to zero, proving the contradiction without an inverse witness,
; a combined ideal, general Groebner-basis construction, or root finding.
;
; Algebraically, this is x^q = x => x^(q^2) = x, the Frobenius identity
; underlying the inclusion F_q in F_(q^2). cvc5 currently exposes only
; prime-field sorts; the power-difference ideal captures the extension-field
; identity without constructing an F_(q^2) sort.
; `ff.pow` is the compact indexed operator added by this research prototype.
(set-info :category "crafted")
(set-info :status unsat)
(set-logic QF_FF)
(define-sort F ()
  (_ FiniteField
     21888242871839275222246405745257275088696311157297823662689037894645226208583))
(declare-fun x () F)

(assert
  (not
    (=> (= ((_ ff.pow
               21888242871839275222246405745257275088696311157297823662689037894645226208583)
             x)
            x)
        (= ((_ ff.pow
               479095176016622842441988045216678740799252316531100822436447802254070093686378237447841051819437871971188232314813100261836255634139586948646393022867889)
             x)
            x))))
(check-sat)
