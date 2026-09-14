; Research proof of concept: BN254 finite-field power expansion.
;
; This file is intentionally not registered as a cvc5 regression. It uses
; only the existing ff.mul operator to encode the Frobenius implication
;
;   x^q = x  =>  x^(q^2) = x
;
; for the BN254 base-field prime q = 21888242871839275222246405745257275088696311157297823662689037894645226208583.
;
; x_pow_2_i denotes x^(2^i). Although repeated squaring keeps this source
; small, cvc5 expands the zero-argument definitions and flattens ff.mul.
; The x^(q^2) term then has q^2 = 479095176016622842441988045216678740799252316531100822436447802254070093686378237447841051819437871971188232314813100261836255634139586948646393022867889
; occurrences of x. Current cvc5 is therefore not expected to finish this
; naive encoding. The compact ff.pow benchmark in the regression suite
; exercises PowerDifferenceIdealMembership instead.
;
; Run manually only when measuring the baseline limitation:
;   build/bin/cvc5 \
;     contrib/power_difference/benchmarks/bn254_multiplication_expansion.smt2

(set-info :smt-lib-version 2.6)
(set-info :category "crafted")
(set-info :status unsat)
(set-logic QF_FF)
(define-sort F () (_ FiniteField 21888242871839275222246405745257275088696311157297823662689037894645226208583))
(declare-fun x () F)

(define-fun x_pow_2_0 () F x)
(define-fun x_pow_2_1 () F
  (ff.mul x_pow_2_0 x_pow_2_0))
(define-fun x_pow_2_2 () F
  (ff.mul x_pow_2_1 x_pow_2_1))
(define-fun x_pow_2_3 () F
  (ff.mul x_pow_2_2 x_pow_2_2))
(define-fun x_pow_2_4 () F
  (ff.mul x_pow_2_3 x_pow_2_3))
(define-fun x_pow_2_5 () F
  (ff.mul x_pow_2_4 x_pow_2_4))
(define-fun x_pow_2_6 () F
  (ff.mul x_pow_2_5 x_pow_2_5))
(define-fun x_pow_2_7 () F
  (ff.mul x_pow_2_6 x_pow_2_6))
(define-fun x_pow_2_8 () F
  (ff.mul x_pow_2_7 x_pow_2_7))
(define-fun x_pow_2_9 () F
  (ff.mul x_pow_2_8 x_pow_2_8))
(define-fun x_pow_2_10 () F
  (ff.mul x_pow_2_9 x_pow_2_9))
(define-fun x_pow_2_11 () F
  (ff.mul x_pow_2_10 x_pow_2_10))
(define-fun x_pow_2_12 () F
  (ff.mul x_pow_2_11 x_pow_2_11))
(define-fun x_pow_2_13 () F
  (ff.mul x_pow_2_12 x_pow_2_12))
(define-fun x_pow_2_14 () F
  (ff.mul x_pow_2_13 x_pow_2_13))
(define-fun x_pow_2_15 () F
  (ff.mul x_pow_2_14 x_pow_2_14))
(define-fun x_pow_2_16 () F
  (ff.mul x_pow_2_15 x_pow_2_15))
(define-fun x_pow_2_17 () F
  (ff.mul x_pow_2_16 x_pow_2_16))
(define-fun x_pow_2_18 () F
  (ff.mul x_pow_2_17 x_pow_2_17))
(define-fun x_pow_2_19 () F
  (ff.mul x_pow_2_18 x_pow_2_18))
(define-fun x_pow_2_20 () F
  (ff.mul x_pow_2_19 x_pow_2_19))
(define-fun x_pow_2_21 () F
  (ff.mul x_pow_2_20 x_pow_2_20))
(define-fun x_pow_2_22 () F
  (ff.mul x_pow_2_21 x_pow_2_21))
(define-fun x_pow_2_23 () F
  (ff.mul x_pow_2_22 x_pow_2_22))
(define-fun x_pow_2_24 () F
  (ff.mul x_pow_2_23 x_pow_2_23))
(define-fun x_pow_2_25 () F
  (ff.mul x_pow_2_24 x_pow_2_24))
(define-fun x_pow_2_26 () F
  (ff.mul x_pow_2_25 x_pow_2_25))
(define-fun x_pow_2_27 () F
  (ff.mul x_pow_2_26 x_pow_2_26))
(define-fun x_pow_2_28 () F
  (ff.mul x_pow_2_27 x_pow_2_27))
(define-fun x_pow_2_29 () F
  (ff.mul x_pow_2_28 x_pow_2_28))
(define-fun x_pow_2_30 () F
  (ff.mul x_pow_2_29 x_pow_2_29))
(define-fun x_pow_2_31 () F
  (ff.mul x_pow_2_30 x_pow_2_30))
(define-fun x_pow_2_32 () F
  (ff.mul x_pow_2_31 x_pow_2_31))
(define-fun x_pow_2_33 () F
  (ff.mul x_pow_2_32 x_pow_2_32))
(define-fun x_pow_2_34 () F
  (ff.mul x_pow_2_33 x_pow_2_33))
(define-fun x_pow_2_35 () F
  (ff.mul x_pow_2_34 x_pow_2_34))
(define-fun x_pow_2_36 () F
  (ff.mul x_pow_2_35 x_pow_2_35))
(define-fun x_pow_2_37 () F
  (ff.mul x_pow_2_36 x_pow_2_36))
(define-fun x_pow_2_38 () F
  (ff.mul x_pow_2_37 x_pow_2_37))
(define-fun x_pow_2_39 () F
  (ff.mul x_pow_2_38 x_pow_2_38))
(define-fun x_pow_2_40 () F
  (ff.mul x_pow_2_39 x_pow_2_39))
(define-fun x_pow_2_41 () F
  (ff.mul x_pow_2_40 x_pow_2_40))
(define-fun x_pow_2_42 () F
  (ff.mul x_pow_2_41 x_pow_2_41))
(define-fun x_pow_2_43 () F
  (ff.mul x_pow_2_42 x_pow_2_42))
(define-fun x_pow_2_44 () F
  (ff.mul x_pow_2_43 x_pow_2_43))
(define-fun x_pow_2_45 () F
  (ff.mul x_pow_2_44 x_pow_2_44))
(define-fun x_pow_2_46 () F
  (ff.mul x_pow_2_45 x_pow_2_45))
(define-fun x_pow_2_47 () F
  (ff.mul x_pow_2_46 x_pow_2_46))
(define-fun x_pow_2_48 () F
  (ff.mul x_pow_2_47 x_pow_2_47))
(define-fun x_pow_2_49 () F
  (ff.mul x_pow_2_48 x_pow_2_48))
(define-fun x_pow_2_50 () F
  (ff.mul x_pow_2_49 x_pow_2_49))
(define-fun x_pow_2_51 () F
  (ff.mul x_pow_2_50 x_pow_2_50))
(define-fun x_pow_2_52 () F
  (ff.mul x_pow_2_51 x_pow_2_51))
(define-fun x_pow_2_53 () F
  (ff.mul x_pow_2_52 x_pow_2_52))
(define-fun x_pow_2_54 () F
  (ff.mul x_pow_2_53 x_pow_2_53))
(define-fun x_pow_2_55 () F
  (ff.mul x_pow_2_54 x_pow_2_54))
(define-fun x_pow_2_56 () F
  (ff.mul x_pow_2_55 x_pow_2_55))
(define-fun x_pow_2_57 () F
  (ff.mul x_pow_2_56 x_pow_2_56))
(define-fun x_pow_2_58 () F
  (ff.mul x_pow_2_57 x_pow_2_57))
(define-fun x_pow_2_59 () F
  (ff.mul x_pow_2_58 x_pow_2_58))
(define-fun x_pow_2_60 () F
  (ff.mul x_pow_2_59 x_pow_2_59))
(define-fun x_pow_2_61 () F
  (ff.mul x_pow_2_60 x_pow_2_60))
(define-fun x_pow_2_62 () F
  (ff.mul x_pow_2_61 x_pow_2_61))
(define-fun x_pow_2_63 () F
  (ff.mul x_pow_2_62 x_pow_2_62))
(define-fun x_pow_2_64 () F
  (ff.mul x_pow_2_63 x_pow_2_63))
(define-fun x_pow_2_65 () F
  (ff.mul x_pow_2_64 x_pow_2_64))
(define-fun x_pow_2_66 () F
  (ff.mul x_pow_2_65 x_pow_2_65))
(define-fun x_pow_2_67 () F
  (ff.mul x_pow_2_66 x_pow_2_66))
(define-fun x_pow_2_68 () F
  (ff.mul x_pow_2_67 x_pow_2_67))
(define-fun x_pow_2_69 () F
  (ff.mul x_pow_2_68 x_pow_2_68))
(define-fun x_pow_2_70 () F
  (ff.mul x_pow_2_69 x_pow_2_69))
(define-fun x_pow_2_71 () F
  (ff.mul x_pow_2_70 x_pow_2_70))
(define-fun x_pow_2_72 () F
  (ff.mul x_pow_2_71 x_pow_2_71))
(define-fun x_pow_2_73 () F
  (ff.mul x_pow_2_72 x_pow_2_72))
(define-fun x_pow_2_74 () F
  (ff.mul x_pow_2_73 x_pow_2_73))
(define-fun x_pow_2_75 () F
  (ff.mul x_pow_2_74 x_pow_2_74))
(define-fun x_pow_2_76 () F
  (ff.mul x_pow_2_75 x_pow_2_75))
(define-fun x_pow_2_77 () F
  (ff.mul x_pow_2_76 x_pow_2_76))
(define-fun x_pow_2_78 () F
  (ff.mul x_pow_2_77 x_pow_2_77))
(define-fun x_pow_2_79 () F
  (ff.mul x_pow_2_78 x_pow_2_78))
(define-fun x_pow_2_80 () F
  (ff.mul x_pow_2_79 x_pow_2_79))
(define-fun x_pow_2_81 () F
  (ff.mul x_pow_2_80 x_pow_2_80))
(define-fun x_pow_2_82 () F
  (ff.mul x_pow_2_81 x_pow_2_81))
(define-fun x_pow_2_83 () F
  (ff.mul x_pow_2_82 x_pow_2_82))
(define-fun x_pow_2_84 () F
  (ff.mul x_pow_2_83 x_pow_2_83))
(define-fun x_pow_2_85 () F
  (ff.mul x_pow_2_84 x_pow_2_84))
(define-fun x_pow_2_86 () F
  (ff.mul x_pow_2_85 x_pow_2_85))
(define-fun x_pow_2_87 () F
  (ff.mul x_pow_2_86 x_pow_2_86))
(define-fun x_pow_2_88 () F
  (ff.mul x_pow_2_87 x_pow_2_87))
(define-fun x_pow_2_89 () F
  (ff.mul x_pow_2_88 x_pow_2_88))
(define-fun x_pow_2_90 () F
  (ff.mul x_pow_2_89 x_pow_2_89))
(define-fun x_pow_2_91 () F
  (ff.mul x_pow_2_90 x_pow_2_90))
(define-fun x_pow_2_92 () F
  (ff.mul x_pow_2_91 x_pow_2_91))
(define-fun x_pow_2_93 () F
  (ff.mul x_pow_2_92 x_pow_2_92))
(define-fun x_pow_2_94 () F
  (ff.mul x_pow_2_93 x_pow_2_93))
(define-fun x_pow_2_95 () F
  (ff.mul x_pow_2_94 x_pow_2_94))
(define-fun x_pow_2_96 () F
  (ff.mul x_pow_2_95 x_pow_2_95))
(define-fun x_pow_2_97 () F
  (ff.mul x_pow_2_96 x_pow_2_96))
(define-fun x_pow_2_98 () F
  (ff.mul x_pow_2_97 x_pow_2_97))
(define-fun x_pow_2_99 () F
  (ff.mul x_pow_2_98 x_pow_2_98))
(define-fun x_pow_2_100 () F
  (ff.mul x_pow_2_99 x_pow_2_99))
(define-fun x_pow_2_101 () F
  (ff.mul x_pow_2_100 x_pow_2_100))
(define-fun x_pow_2_102 () F
  (ff.mul x_pow_2_101 x_pow_2_101))
(define-fun x_pow_2_103 () F
  (ff.mul x_pow_2_102 x_pow_2_102))
(define-fun x_pow_2_104 () F
  (ff.mul x_pow_2_103 x_pow_2_103))
(define-fun x_pow_2_105 () F
  (ff.mul x_pow_2_104 x_pow_2_104))
(define-fun x_pow_2_106 () F
  (ff.mul x_pow_2_105 x_pow_2_105))
(define-fun x_pow_2_107 () F
  (ff.mul x_pow_2_106 x_pow_2_106))
(define-fun x_pow_2_108 () F
  (ff.mul x_pow_2_107 x_pow_2_107))
(define-fun x_pow_2_109 () F
  (ff.mul x_pow_2_108 x_pow_2_108))
(define-fun x_pow_2_110 () F
  (ff.mul x_pow_2_109 x_pow_2_109))
(define-fun x_pow_2_111 () F
  (ff.mul x_pow_2_110 x_pow_2_110))
(define-fun x_pow_2_112 () F
  (ff.mul x_pow_2_111 x_pow_2_111))
(define-fun x_pow_2_113 () F
  (ff.mul x_pow_2_112 x_pow_2_112))
(define-fun x_pow_2_114 () F
  (ff.mul x_pow_2_113 x_pow_2_113))
(define-fun x_pow_2_115 () F
  (ff.mul x_pow_2_114 x_pow_2_114))
(define-fun x_pow_2_116 () F
  (ff.mul x_pow_2_115 x_pow_2_115))
(define-fun x_pow_2_117 () F
  (ff.mul x_pow_2_116 x_pow_2_116))
(define-fun x_pow_2_118 () F
  (ff.mul x_pow_2_117 x_pow_2_117))
(define-fun x_pow_2_119 () F
  (ff.mul x_pow_2_118 x_pow_2_118))
(define-fun x_pow_2_120 () F
  (ff.mul x_pow_2_119 x_pow_2_119))
(define-fun x_pow_2_121 () F
  (ff.mul x_pow_2_120 x_pow_2_120))
(define-fun x_pow_2_122 () F
  (ff.mul x_pow_2_121 x_pow_2_121))
(define-fun x_pow_2_123 () F
  (ff.mul x_pow_2_122 x_pow_2_122))
(define-fun x_pow_2_124 () F
  (ff.mul x_pow_2_123 x_pow_2_123))
(define-fun x_pow_2_125 () F
  (ff.mul x_pow_2_124 x_pow_2_124))
(define-fun x_pow_2_126 () F
  (ff.mul x_pow_2_125 x_pow_2_125))
(define-fun x_pow_2_127 () F
  (ff.mul x_pow_2_126 x_pow_2_126))
(define-fun x_pow_2_128 () F
  (ff.mul x_pow_2_127 x_pow_2_127))
(define-fun x_pow_2_129 () F
  (ff.mul x_pow_2_128 x_pow_2_128))
(define-fun x_pow_2_130 () F
  (ff.mul x_pow_2_129 x_pow_2_129))
(define-fun x_pow_2_131 () F
  (ff.mul x_pow_2_130 x_pow_2_130))
(define-fun x_pow_2_132 () F
  (ff.mul x_pow_2_131 x_pow_2_131))
(define-fun x_pow_2_133 () F
  (ff.mul x_pow_2_132 x_pow_2_132))
(define-fun x_pow_2_134 () F
  (ff.mul x_pow_2_133 x_pow_2_133))
(define-fun x_pow_2_135 () F
  (ff.mul x_pow_2_134 x_pow_2_134))
(define-fun x_pow_2_136 () F
  (ff.mul x_pow_2_135 x_pow_2_135))
(define-fun x_pow_2_137 () F
  (ff.mul x_pow_2_136 x_pow_2_136))
(define-fun x_pow_2_138 () F
  (ff.mul x_pow_2_137 x_pow_2_137))
(define-fun x_pow_2_139 () F
  (ff.mul x_pow_2_138 x_pow_2_138))
(define-fun x_pow_2_140 () F
  (ff.mul x_pow_2_139 x_pow_2_139))
(define-fun x_pow_2_141 () F
  (ff.mul x_pow_2_140 x_pow_2_140))
(define-fun x_pow_2_142 () F
  (ff.mul x_pow_2_141 x_pow_2_141))
(define-fun x_pow_2_143 () F
  (ff.mul x_pow_2_142 x_pow_2_142))
(define-fun x_pow_2_144 () F
  (ff.mul x_pow_2_143 x_pow_2_143))
(define-fun x_pow_2_145 () F
  (ff.mul x_pow_2_144 x_pow_2_144))
(define-fun x_pow_2_146 () F
  (ff.mul x_pow_2_145 x_pow_2_145))
(define-fun x_pow_2_147 () F
  (ff.mul x_pow_2_146 x_pow_2_146))
(define-fun x_pow_2_148 () F
  (ff.mul x_pow_2_147 x_pow_2_147))
(define-fun x_pow_2_149 () F
  (ff.mul x_pow_2_148 x_pow_2_148))
(define-fun x_pow_2_150 () F
  (ff.mul x_pow_2_149 x_pow_2_149))
(define-fun x_pow_2_151 () F
  (ff.mul x_pow_2_150 x_pow_2_150))
(define-fun x_pow_2_152 () F
  (ff.mul x_pow_2_151 x_pow_2_151))
(define-fun x_pow_2_153 () F
  (ff.mul x_pow_2_152 x_pow_2_152))
(define-fun x_pow_2_154 () F
  (ff.mul x_pow_2_153 x_pow_2_153))
(define-fun x_pow_2_155 () F
  (ff.mul x_pow_2_154 x_pow_2_154))
(define-fun x_pow_2_156 () F
  (ff.mul x_pow_2_155 x_pow_2_155))
(define-fun x_pow_2_157 () F
  (ff.mul x_pow_2_156 x_pow_2_156))
(define-fun x_pow_2_158 () F
  (ff.mul x_pow_2_157 x_pow_2_157))
(define-fun x_pow_2_159 () F
  (ff.mul x_pow_2_158 x_pow_2_158))
(define-fun x_pow_2_160 () F
  (ff.mul x_pow_2_159 x_pow_2_159))
(define-fun x_pow_2_161 () F
  (ff.mul x_pow_2_160 x_pow_2_160))
(define-fun x_pow_2_162 () F
  (ff.mul x_pow_2_161 x_pow_2_161))
(define-fun x_pow_2_163 () F
  (ff.mul x_pow_2_162 x_pow_2_162))
(define-fun x_pow_2_164 () F
  (ff.mul x_pow_2_163 x_pow_2_163))
(define-fun x_pow_2_165 () F
  (ff.mul x_pow_2_164 x_pow_2_164))
(define-fun x_pow_2_166 () F
  (ff.mul x_pow_2_165 x_pow_2_165))
(define-fun x_pow_2_167 () F
  (ff.mul x_pow_2_166 x_pow_2_166))
(define-fun x_pow_2_168 () F
  (ff.mul x_pow_2_167 x_pow_2_167))
(define-fun x_pow_2_169 () F
  (ff.mul x_pow_2_168 x_pow_2_168))
(define-fun x_pow_2_170 () F
  (ff.mul x_pow_2_169 x_pow_2_169))
(define-fun x_pow_2_171 () F
  (ff.mul x_pow_2_170 x_pow_2_170))
(define-fun x_pow_2_172 () F
  (ff.mul x_pow_2_171 x_pow_2_171))
(define-fun x_pow_2_173 () F
  (ff.mul x_pow_2_172 x_pow_2_172))
(define-fun x_pow_2_174 () F
  (ff.mul x_pow_2_173 x_pow_2_173))
(define-fun x_pow_2_175 () F
  (ff.mul x_pow_2_174 x_pow_2_174))
(define-fun x_pow_2_176 () F
  (ff.mul x_pow_2_175 x_pow_2_175))
(define-fun x_pow_2_177 () F
  (ff.mul x_pow_2_176 x_pow_2_176))
(define-fun x_pow_2_178 () F
  (ff.mul x_pow_2_177 x_pow_2_177))
(define-fun x_pow_2_179 () F
  (ff.mul x_pow_2_178 x_pow_2_178))
(define-fun x_pow_2_180 () F
  (ff.mul x_pow_2_179 x_pow_2_179))
(define-fun x_pow_2_181 () F
  (ff.mul x_pow_2_180 x_pow_2_180))
(define-fun x_pow_2_182 () F
  (ff.mul x_pow_2_181 x_pow_2_181))
(define-fun x_pow_2_183 () F
  (ff.mul x_pow_2_182 x_pow_2_182))
(define-fun x_pow_2_184 () F
  (ff.mul x_pow_2_183 x_pow_2_183))
(define-fun x_pow_2_185 () F
  (ff.mul x_pow_2_184 x_pow_2_184))
(define-fun x_pow_2_186 () F
  (ff.mul x_pow_2_185 x_pow_2_185))
(define-fun x_pow_2_187 () F
  (ff.mul x_pow_2_186 x_pow_2_186))
(define-fun x_pow_2_188 () F
  (ff.mul x_pow_2_187 x_pow_2_187))
(define-fun x_pow_2_189 () F
  (ff.mul x_pow_2_188 x_pow_2_188))
(define-fun x_pow_2_190 () F
  (ff.mul x_pow_2_189 x_pow_2_189))
(define-fun x_pow_2_191 () F
  (ff.mul x_pow_2_190 x_pow_2_190))
(define-fun x_pow_2_192 () F
  (ff.mul x_pow_2_191 x_pow_2_191))
(define-fun x_pow_2_193 () F
  (ff.mul x_pow_2_192 x_pow_2_192))
(define-fun x_pow_2_194 () F
  (ff.mul x_pow_2_193 x_pow_2_193))
(define-fun x_pow_2_195 () F
  (ff.mul x_pow_2_194 x_pow_2_194))
(define-fun x_pow_2_196 () F
  (ff.mul x_pow_2_195 x_pow_2_195))
(define-fun x_pow_2_197 () F
  (ff.mul x_pow_2_196 x_pow_2_196))
(define-fun x_pow_2_198 () F
  (ff.mul x_pow_2_197 x_pow_2_197))
(define-fun x_pow_2_199 () F
  (ff.mul x_pow_2_198 x_pow_2_198))
(define-fun x_pow_2_200 () F
  (ff.mul x_pow_2_199 x_pow_2_199))
(define-fun x_pow_2_201 () F
  (ff.mul x_pow_2_200 x_pow_2_200))
(define-fun x_pow_2_202 () F
  (ff.mul x_pow_2_201 x_pow_2_201))
(define-fun x_pow_2_203 () F
  (ff.mul x_pow_2_202 x_pow_2_202))
(define-fun x_pow_2_204 () F
  (ff.mul x_pow_2_203 x_pow_2_203))
(define-fun x_pow_2_205 () F
  (ff.mul x_pow_2_204 x_pow_2_204))
(define-fun x_pow_2_206 () F
  (ff.mul x_pow_2_205 x_pow_2_205))
(define-fun x_pow_2_207 () F
  (ff.mul x_pow_2_206 x_pow_2_206))
(define-fun x_pow_2_208 () F
  (ff.mul x_pow_2_207 x_pow_2_207))
(define-fun x_pow_2_209 () F
  (ff.mul x_pow_2_208 x_pow_2_208))
(define-fun x_pow_2_210 () F
  (ff.mul x_pow_2_209 x_pow_2_209))
(define-fun x_pow_2_211 () F
  (ff.mul x_pow_2_210 x_pow_2_210))
(define-fun x_pow_2_212 () F
  (ff.mul x_pow_2_211 x_pow_2_211))
(define-fun x_pow_2_213 () F
  (ff.mul x_pow_2_212 x_pow_2_212))
(define-fun x_pow_2_214 () F
  (ff.mul x_pow_2_213 x_pow_2_213))
(define-fun x_pow_2_215 () F
  (ff.mul x_pow_2_214 x_pow_2_214))
(define-fun x_pow_2_216 () F
  (ff.mul x_pow_2_215 x_pow_2_215))
(define-fun x_pow_2_217 () F
  (ff.mul x_pow_2_216 x_pow_2_216))
(define-fun x_pow_2_218 () F
  (ff.mul x_pow_2_217 x_pow_2_217))
(define-fun x_pow_2_219 () F
  (ff.mul x_pow_2_218 x_pow_2_218))
(define-fun x_pow_2_220 () F
  (ff.mul x_pow_2_219 x_pow_2_219))
(define-fun x_pow_2_221 () F
  (ff.mul x_pow_2_220 x_pow_2_220))
(define-fun x_pow_2_222 () F
  (ff.mul x_pow_2_221 x_pow_2_221))
(define-fun x_pow_2_223 () F
  (ff.mul x_pow_2_222 x_pow_2_222))
(define-fun x_pow_2_224 () F
  (ff.mul x_pow_2_223 x_pow_2_223))
(define-fun x_pow_2_225 () F
  (ff.mul x_pow_2_224 x_pow_2_224))
(define-fun x_pow_2_226 () F
  (ff.mul x_pow_2_225 x_pow_2_225))
(define-fun x_pow_2_227 () F
  (ff.mul x_pow_2_226 x_pow_2_226))
(define-fun x_pow_2_228 () F
  (ff.mul x_pow_2_227 x_pow_2_227))
(define-fun x_pow_2_229 () F
  (ff.mul x_pow_2_228 x_pow_2_228))
(define-fun x_pow_2_230 () F
  (ff.mul x_pow_2_229 x_pow_2_229))
(define-fun x_pow_2_231 () F
  (ff.mul x_pow_2_230 x_pow_2_230))
(define-fun x_pow_2_232 () F
  (ff.mul x_pow_2_231 x_pow_2_231))
(define-fun x_pow_2_233 () F
  (ff.mul x_pow_2_232 x_pow_2_232))
(define-fun x_pow_2_234 () F
  (ff.mul x_pow_2_233 x_pow_2_233))
(define-fun x_pow_2_235 () F
  (ff.mul x_pow_2_234 x_pow_2_234))
(define-fun x_pow_2_236 () F
  (ff.mul x_pow_2_235 x_pow_2_235))
(define-fun x_pow_2_237 () F
  (ff.mul x_pow_2_236 x_pow_2_236))
(define-fun x_pow_2_238 () F
  (ff.mul x_pow_2_237 x_pow_2_237))
(define-fun x_pow_2_239 () F
  (ff.mul x_pow_2_238 x_pow_2_238))
(define-fun x_pow_2_240 () F
  (ff.mul x_pow_2_239 x_pow_2_239))
(define-fun x_pow_2_241 () F
  (ff.mul x_pow_2_240 x_pow_2_240))
(define-fun x_pow_2_242 () F
  (ff.mul x_pow_2_241 x_pow_2_241))
(define-fun x_pow_2_243 () F
  (ff.mul x_pow_2_242 x_pow_2_242))
(define-fun x_pow_2_244 () F
  (ff.mul x_pow_2_243 x_pow_2_243))
(define-fun x_pow_2_245 () F
  (ff.mul x_pow_2_244 x_pow_2_244))
(define-fun x_pow_2_246 () F
  (ff.mul x_pow_2_245 x_pow_2_245))
(define-fun x_pow_2_247 () F
  (ff.mul x_pow_2_246 x_pow_2_246))
(define-fun x_pow_2_248 () F
  (ff.mul x_pow_2_247 x_pow_2_247))
(define-fun x_pow_2_249 () F
  (ff.mul x_pow_2_248 x_pow_2_248))
(define-fun x_pow_2_250 () F
  (ff.mul x_pow_2_249 x_pow_2_249))
(define-fun x_pow_2_251 () F
  (ff.mul x_pow_2_250 x_pow_2_250))
(define-fun x_pow_2_252 () F
  (ff.mul x_pow_2_251 x_pow_2_251))
(define-fun x_pow_2_253 () F
  (ff.mul x_pow_2_252 x_pow_2_252))
(define-fun x_pow_2_254 () F
  (ff.mul x_pow_2_253 x_pow_2_253))
(define-fun x_pow_2_255 () F
  (ff.mul x_pow_2_254 x_pow_2_254))
(define-fun x_pow_2_256 () F
  (ff.mul x_pow_2_255 x_pow_2_255))
(define-fun x_pow_2_257 () F
  (ff.mul x_pow_2_256 x_pow_2_256))
(define-fun x_pow_2_258 () F
  (ff.mul x_pow_2_257 x_pow_2_257))
(define-fun x_pow_2_259 () F
  (ff.mul x_pow_2_258 x_pow_2_258))
(define-fun x_pow_2_260 () F
  (ff.mul x_pow_2_259 x_pow_2_259))
(define-fun x_pow_2_261 () F
  (ff.mul x_pow_2_260 x_pow_2_260))
(define-fun x_pow_2_262 () F
  (ff.mul x_pow_2_261 x_pow_2_261))
(define-fun x_pow_2_263 () F
  (ff.mul x_pow_2_262 x_pow_2_262))
(define-fun x_pow_2_264 () F
  (ff.mul x_pow_2_263 x_pow_2_263))
(define-fun x_pow_2_265 () F
  (ff.mul x_pow_2_264 x_pow_2_264))
(define-fun x_pow_2_266 () F
  (ff.mul x_pow_2_265 x_pow_2_265))
(define-fun x_pow_2_267 () F
  (ff.mul x_pow_2_266 x_pow_2_266))
(define-fun x_pow_2_268 () F
  (ff.mul x_pow_2_267 x_pow_2_267))
(define-fun x_pow_2_269 () F
  (ff.mul x_pow_2_268 x_pow_2_268))
(define-fun x_pow_2_270 () F
  (ff.mul x_pow_2_269 x_pow_2_269))
(define-fun x_pow_2_271 () F
  (ff.mul x_pow_2_270 x_pow_2_270))
(define-fun x_pow_2_272 () F
  (ff.mul x_pow_2_271 x_pow_2_271))
(define-fun x_pow_2_273 () F
  (ff.mul x_pow_2_272 x_pow_2_272))
(define-fun x_pow_2_274 () F
  (ff.mul x_pow_2_273 x_pow_2_273))
(define-fun x_pow_2_275 () F
  (ff.mul x_pow_2_274 x_pow_2_274))
(define-fun x_pow_2_276 () F
  (ff.mul x_pow_2_275 x_pow_2_275))
(define-fun x_pow_2_277 () F
  (ff.mul x_pow_2_276 x_pow_2_276))
(define-fun x_pow_2_278 () F
  (ff.mul x_pow_2_277 x_pow_2_277))
(define-fun x_pow_2_279 () F
  (ff.mul x_pow_2_278 x_pow_2_278))
(define-fun x_pow_2_280 () F
  (ff.mul x_pow_2_279 x_pow_2_279))
(define-fun x_pow_2_281 () F
  (ff.mul x_pow_2_280 x_pow_2_280))
(define-fun x_pow_2_282 () F
  (ff.mul x_pow_2_281 x_pow_2_281))
(define-fun x_pow_2_283 () F
  (ff.mul x_pow_2_282 x_pow_2_282))
(define-fun x_pow_2_284 () F
  (ff.mul x_pow_2_283 x_pow_2_283))
(define-fun x_pow_2_285 () F
  (ff.mul x_pow_2_284 x_pow_2_284))
(define-fun x_pow_2_286 () F
  (ff.mul x_pow_2_285 x_pow_2_285))
(define-fun x_pow_2_287 () F
  (ff.mul x_pow_2_286 x_pow_2_286))
(define-fun x_pow_2_288 () F
  (ff.mul x_pow_2_287 x_pow_2_287))
(define-fun x_pow_2_289 () F
  (ff.mul x_pow_2_288 x_pow_2_288))
(define-fun x_pow_2_290 () F
  (ff.mul x_pow_2_289 x_pow_2_289))
(define-fun x_pow_2_291 () F
  (ff.mul x_pow_2_290 x_pow_2_290))
(define-fun x_pow_2_292 () F
  (ff.mul x_pow_2_291 x_pow_2_291))
(define-fun x_pow_2_293 () F
  (ff.mul x_pow_2_292 x_pow_2_292))
(define-fun x_pow_2_294 () F
  (ff.mul x_pow_2_293 x_pow_2_293))
(define-fun x_pow_2_295 () F
  (ff.mul x_pow_2_294 x_pow_2_294))
(define-fun x_pow_2_296 () F
  (ff.mul x_pow_2_295 x_pow_2_295))
(define-fun x_pow_2_297 () F
  (ff.mul x_pow_2_296 x_pow_2_296))
(define-fun x_pow_2_298 () F
  (ff.mul x_pow_2_297 x_pow_2_297))
(define-fun x_pow_2_299 () F
  (ff.mul x_pow_2_298 x_pow_2_298))
(define-fun x_pow_2_300 () F
  (ff.mul x_pow_2_299 x_pow_2_299))
(define-fun x_pow_2_301 () F
  (ff.mul x_pow_2_300 x_pow_2_300))
(define-fun x_pow_2_302 () F
  (ff.mul x_pow_2_301 x_pow_2_301))
(define-fun x_pow_2_303 () F
  (ff.mul x_pow_2_302 x_pow_2_302))
(define-fun x_pow_2_304 () F
  (ff.mul x_pow_2_303 x_pow_2_303))
(define-fun x_pow_2_305 () F
  (ff.mul x_pow_2_304 x_pow_2_304))
(define-fun x_pow_2_306 () F
  (ff.mul x_pow_2_305 x_pow_2_305))
(define-fun x_pow_2_307 () F
  (ff.mul x_pow_2_306 x_pow_2_306))
(define-fun x_pow_2_308 () F
  (ff.mul x_pow_2_307 x_pow_2_307))
(define-fun x_pow_2_309 () F
  (ff.mul x_pow_2_308 x_pow_2_308))
(define-fun x_pow_2_310 () F
  (ff.mul x_pow_2_309 x_pow_2_309))
(define-fun x_pow_2_311 () F
  (ff.mul x_pow_2_310 x_pow_2_310))
(define-fun x_pow_2_312 () F
  (ff.mul x_pow_2_311 x_pow_2_311))
(define-fun x_pow_2_313 () F
  (ff.mul x_pow_2_312 x_pow_2_312))
(define-fun x_pow_2_314 () F
  (ff.mul x_pow_2_313 x_pow_2_313))
(define-fun x_pow_2_315 () F
  (ff.mul x_pow_2_314 x_pow_2_314))
(define-fun x_pow_2_316 () F
  (ff.mul x_pow_2_315 x_pow_2_315))
(define-fun x_pow_2_317 () F
  (ff.mul x_pow_2_316 x_pow_2_316))
(define-fun x_pow_2_318 () F
  (ff.mul x_pow_2_317 x_pow_2_317))
(define-fun x_pow_2_319 () F
  (ff.mul x_pow_2_318 x_pow_2_318))
(define-fun x_pow_2_320 () F
  (ff.mul x_pow_2_319 x_pow_2_319))
(define-fun x_pow_2_321 () F
  (ff.mul x_pow_2_320 x_pow_2_320))
(define-fun x_pow_2_322 () F
  (ff.mul x_pow_2_321 x_pow_2_321))
(define-fun x_pow_2_323 () F
  (ff.mul x_pow_2_322 x_pow_2_322))
(define-fun x_pow_2_324 () F
  (ff.mul x_pow_2_323 x_pow_2_323))
(define-fun x_pow_2_325 () F
  (ff.mul x_pow_2_324 x_pow_2_324))
(define-fun x_pow_2_326 () F
  (ff.mul x_pow_2_325 x_pow_2_325))
(define-fun x_pow_2_327 () F
  (ff.mul x_pow_2_326 x_pow_2_326))
(define-fun x_pow_2_328 () F
  (ff.mul x_pow_2_327 x_pow_2_327))
(define-fun x_pow_2_329 () F
  (ff.mul x_pow_2_328 x_pow_2_328))
(define-fun x_pow_2_330 () F
  (ff.mul x_pow_2_329 x_pow_2_329))
(define-fun x_pow_2_331 () F
  (ff.mul x_pow_2_330 x_pow_2_330))
(define-fun x_pow_2_332 () F
  (ff.mul x_pow_2_331 x_pow_2_331))
(define-fun x_pow_2_333 () F
  (ff.mul x_pow_2_332 x_pow_2_332))
(define-fun x_pow_2_334 () F
  (ff.mul x_pow_2_333 x_pow_2_333))
(define-fun x_pow_2_335 () F
  (ff.mul x_pow_2_334 x_pow_2_334))
(define-fun x_pow_2_336 () F
  (ff.mul x_pow_2_335 x_pow_2_335))
(define-fun x_pow_2_337 () F
  (ff.mul x_pow_2_336 x_pow_2_336))
(define-fun x_pow_2_338 () F
  (ff.mul x_pow_2_337 x_pow_2_337))
(define-fun x_pow_2_339 () F
  (ff.mul x_pow_2_338 x_pow_2_338))
(define-fun x_pow_2_340 () F
  (ff.mul x_pow_2_339 x_pow_2_339))
(define-fun x_pow_2_341 () F
  (ff.mul x_pow_2_340 x_pow_2_340))
(define-fun x_pow_2_342 () F
  (ff.mul x_pow_2_341 x_pow_2_341))
(define-fun x_pow_2_343 () F
  (ff.mul x_pow_2_342 x_pow_2_342))
(define-fun x_pow_2_344 () F
  (ff.mul x_pow_2_343 x_pow_2_343))
(define-fun x_pow_2_345 () F
  (ff.mul x_pow_2_344 x_pow_2_344))
(define-fun x_pow_2_346 () F
  (ff.mul x_pow_2_345 x_pow_2_345))
(define-fun x_pow_2_347 () F
  (ff.mul x_pow_2_346 x_pow_2_346))
(define-fun x_pow_2_348 () F
  (ff.mul x_pow_2_347 x_pow_2_347))
(define-fun x_pow_2_349 () F
  (ff.mul x_pow_2_348 x_pow_2_348))
(define-fun x_pow_2_350 () F
  (ff.mul x_pow_2_349 x_pow_2_349))
(define-fun x_pow_2_351 () F
  (ff.mul x_pow_2_350 x_pow_2_350))
(define-fun x_pow_2_352 () F
  (ff.mul x_pow_2_351 x_pow_2_351))
(define-fun x_pow_2_353 () F
  (ff.mul x_pow_2_352 x_pow_2_352))
(define-fun x_pow_2_354 () F
  (ff.mul x_pow_2_353 x_pow_2_353))
(define-fun x_pow_2_355 () F
  (ff.mul x_pow_2_354 x_pow_2_354))
(define-fun x_pow_2_356 () F
  (ff.mul x_pow_2_355 x_pow_2_355))
(define-fun x_pow_2_357 () F
  (ff.mul x_pow_2_356 x_pow_2_356))
(define-fun x_pow_2_358 () F
  (ff.mul x_pow_2_357 x_pow_2_357))
(define-fun x_pow_2_359 () F
  (ff.mul x_pow_2_358 x_pow_2_358))
(define-fun x_pow_2_360 () F
  (ff.mul x_pow_2_359 x_pow_2_359))
(define-fun x_pow_2_361 () F
  (ff.mul x_pow_2_360 x_pow_2_360))
(define-fun x_pow_2_362 () F
  (ff.mul x_pow_2_361 x_pow_2_361))
(define-fun x_pow_2_363 () F
  (ff.mul x_pow_2_362 x_pow_2_362))
(define-fun x_pow_2_364 () F
  (ff.mul x_pow_2_363 x_pow_2_363))
(define-fun x_pow_2_365 () F
  (ff.mul x_pow_2_364 x_pow_2_364))
(define-fun x_pow_2_366 () F
  (ff.mul x_pow_2_365 x_pow_2_365))
(define-fun x_pow_2_367 () F
  (ff.mul x_pow_2_366 x_pow_2_366))
(define-fun x_pow_2_368 () F
  (ff.mul x_pow_2_367 x_pow_2_367))
(define-fun x_pow_2_369 () F
  (ff.mul x_pow_2_368 x_pow_2_368))
(define-fun x_pow_2_370 () F
  (ff.mul x_pow_2_369 x_pow_2_369))
(define-fun x_pow_2_371 () F
  (ff.mul x_pow_2_370 x_pow_2_370))
(define-fun x_pow_2_372 () F
  (ff.mul x_pow_2_371 x_pow_2_371))
(define-fun x_pow_2_373 () F
  (ff.mul x_pow_2_372 x_pow_2_372))
(define-fun x_pow_2_374 () F
  (ff.mul x_pow_2_373 x_pow_2_373))
(define-fun x_pow_2_375 () F
  (ff.mul x_pow_2_374 x_pow_2_374))
(define-fun x_pow_2_376 () F
  (ff.mul x_pow_2_375 x_pow_2_375))
(define-fun x_pow_2_377 () F
  (ff.mul x_pow_2_376 x_pow_2_376))
(define-fun x_pow_2_378 () F
  (ff.mul x_pow_2_377 x_pow_2_377))
(define-fun x_pow_2_379 () F
  (ff.mul x_pow_2_378 x_pow_2_378))
(define-fun x_pow_2_380 () F
  (ff.mul x_pow_2_379 x_pow_2_379))
(define-fun x_pow_2_381 () F
  (ff.mul x_pow_2_380 x_pow_2_380))
(define-fun x_pow_2_382 () F
  (ff.mul x_pow_2_381 x_pow_2_381))
(define-fun x_pow_2_383 () F
  (ff.mul x_pow_2_382 x_pow_2_382))
(define-fun x_pow_2_384 () F
  (ff.mul x_pow_2_383 x_pow_2_383))
(define-fun x_pow_2_385 () F
  (ff.mul x_pow_2_384 x_pow_2_384))
(define-fun x_pow_2_386 () F
  (ff.mul x_pow_2_385 x_pow_2_385))
(define-fun x_pow_2_387 () F
  (ff.mul x_pow_2_386 x_pow_2_386))
(define-fun x_pow_2_388 () F
  (ff.mul x_pow_2_387 x_pow_2_387))
(define-fun x_pow_2_389 () F
  (ff.mul x_pow_2_388 x_pow_2_388))
(define-fun x_pow_2_390 () F
  (ff.mul x_pow_2_389 x_pow_2_389))
(define-fun x_pow_2_391 () F
  (ff.mul x_pow_2_390 x_pow_2_390))
(define-fun x_pow_2_392 () F
  (ff.mul x_pow_2_391 x_pow_2_391))
(define-fun x_pow_2_393 () F
  (ff.mul x_pow_2_392 x_pow_2_392))
(define-fun x_pow_2_394 () F
  (ff.mul x_pow_2_393 x_pow_2_393))
(define-fun x_pow_2_395 () F
  (ff.mul x_pow_2_394 x_pow_2_394))
(define-fun x_pow_2_396 () F
  (ff.mul x_pow_2_395 x_pow_2_395))
(define-fun x_pow_2_397 () F
  (ff.mul x_pow_2_396 x_pow_2_396))
(define-fun x_pow_2_398 () F
  (ff.mul x_pow_2_397 x_pow_2_397))
(define-fun x_pow_2_399 () F
  (ff.mul x_pow_2_398 x_pow_2_398))
(define-fun x_pow_2_400 () F
  (ff.mul x_pow_2_399 x_pow_2_399))
(define-fun x_pow_2_401 () F
  (ff.mul x_pow_2_400 x_pow_2_400))
(define-fun x_pow_2_402 () F
  (ff.mul x_pow_2_401 x_pow_2_401))
(define-fun x_pow_2_403 () F
  (ff.mul x_pow_2_402 x_pow_2_402))
(define-fun x_pow_2_404 () F
  (ff.mul x_pow_2_403 x_pow_2_403))
(define-fun x_pow_2_405 () F
  (ff.mul x_pow_2_404 x_pow_2_404))
(define-fun x_pow_2_406 () F
  (ff.mul x_pow_2_405 x_pow_2_405))
(define-fun x_pow_2_407 () F
  (ff.mul x_pow_2_406 x_pow_2_406))
(define-fun x_pow_2_408 () F
  (ff.mul x_pow_2_407 x_pow_2_407))
(define-fun x_pow_2_409 () F
  (ff.mul x_pow_2_408 x_pow_2_408))
(define-fun x_pow_2_410 () F
  (ff.mul x_pow_2_409 x_pow_2_409))
(define-fun x_pow_2_411 () F
  (ff.mul x_pow_2_410 x_pow_2_410))
(define-fun x_pow_2_412 () F
  (ff.mul x_pow_2_411 x_pow_2_411))
(define-fun x_pow_2_413 () F
  (ff.mul x_pow_2_412 x_pow_2_412))
(define-fun x_pow_2_414 () F
  (ff.mul x_pow_2_413 x_pow_2_413))
(define-fun x_pow_2_415 () F
  (ff.mul x_pow_2_414 x_pow_2_414))
(define-fun x_pow_2_416 () F
  (ff.mul x_pow_2_415 x_pow_2_415))
(define-fun x_pow_2_417 () F
  (ff.mul x_pow_2_416 x_pow_2_416))
(define-fun x_pow_2_418 () F
  (ff.mul x_pow_2_417 x_pow_2_417))
(define-fun x_pow_2_419 () F
  (ff.mul x_pow_2_418 x_pow_2_418))
(define-fun x_pow_2_420 () F
  (ff.mul x_pow_2_419 x_pow_2_419))
(define-fun x_pow_2_421 () F
  (ff.mul x_pow_2_420 x_pow_2_420))
(define-fun x_pow_2_422 () F
  (ff.mul x_pow_2_421 x_pow_2_421))
(define-fun x_pow_2_423 () F
  (ff.mul x_pow_2_422 x_pow_2_422))
(define-fun x_pow_2_424 () F
  (ff.mul x_pow_2_423 x_pow_2_423))
(define-fun x_pow_2_425 () F
  (ff.mul x_pow_2_424 x_pow_2_424))
(define-fun x_pow_2_426 () F
  (ff.mul x_pow_2_425 x_pow_2_425))
(define-fun x_pow_2_427 () F
  (ff.mul x_pow_2_426 x_pow_2_426))
(define-fun x_pow_2_428 () F
  (ff.mul x_pow_2_427 x_pow_2_427))
(define-fun x_pow_2_429 () F
  (ff.mul x_pow_2_428 x_pow_2_428))
(define-fun x_pow_2_430 () F
  (ff.mul x_pow_2_429 x_pow_2_429))
(define-fun x_pow_2_431 () F
  (ff.mul x_pow_2_430 x_pow_2_430))
(define-fun x_pow_2_432 () F
  (ff.mul x_pow_2_431 x_pow_2_431))
(define-fun x_pow_2_433 () F
  (ff.mul x_pow_2_432 x_pow_2_432))
(define-fun x_pow_2_434 () F
  (ff.mul x_pow_2_433 x_pow_2_433))
(define-fun x_pow_2_435 () F
  (ff.mul x_pow_2_434 x_pow_2_434))
(define-fun x_pow_2_436 () F
  (ff.mul x_pow_2_435 x_pow_2_435))
(define-fun x_pow_2_437 () F
  (ff.mul x_pow_2_436 x_pow_2_436))
(define-fun x_pow_2_438 () F
  (ff.mul x_pow_2_437 x_pow_2_437))
(define-fun x_pow_2_439 () F
  (ff.mul x_pow_2_438 x_pow_2_438))
(define-fun x_pow_2_440 () F
  (ff.mul x_pow_2_439 x_pow_2_439))
(define-fun x_pow_2_441 () F
  (ff.mul x_pow_2_440 x_pow_2_440))
(define-fun x_pow_2_442 () F
  (ff.mul x_pow_2_441 x_pow_2_441))
(define-fun x_pow_2_443 () F
  (ff.mul x_pow_2_442 x_pow_2_442))
(define-fun x_pow_2_444 () F
  (ff.mul x_pow_2_443 x_pow_2_443))
(define-fun x_pow_2_445 () F
  (ff.mul x_pow_2_444 x_pow_2_444))
(define-fun x_pow_2_446 () F
  (ff.mul x_pow_2_445 x_pow_2_445))
(define-fun x_pow_2_447 () F
  (ff.mul x_pow_2_446 x_pow_2_446))
(define-fun x_pow_2_448 () F
  (ff.mul x_pow_2_447 x_pow_2_447))
(define-fun x_pow_2_449 () F
  (ff.mul x_pow_2_448 x_pow_2_448))
(define-fun x_pow_2_450 () F
  (ff.mul x_pow_2_449 x_pow_2_449))
(define-fun x_pow_2_451 () F
  (ff.mul x_pow_2_450 x_pow_2_450))
(define-fun x_pow_2_452 () F
  (ff.mul x_pow_2_451 x_pow_2_451))
(define-fun x_pow_2_453 () F
  (ff.mul x_pow_2_452 x_pow_2_452))
(define-fun x_pow_2_454 () F
  (ff.mul x_pow_2_453 x_pow_2_453))
(define-fun x_pow_2_455 () F
  (ff.mul x_pow_2_454 x_pow_2_454))
(define-fun x_pow_2_456 () F
  (ff.mul x_pow_2_455 x_pow_2_455))
(define-fun x_pow_2_457 () F
  (ff.mul x_pow_2_456 x_pow_2_456))
(define-fun x_pow_2_458 () F
  (ff.mul x_pow_2_457 x_pow_2_457))
(define-fun x_pow_2_459 () F
  (ff.mul x_pow_2_458 x_pow_2_458))
(define-fun x_pow_2_460 () F
  (ff.mul x_pow_2_459 x_pow_2_459))
(define-fun x_pow_2_461 () F
  (ff.mul x_pow_2_460 x_pow_2_460))
(define-fun x_pow_2_462 () F
  (ff.mul x_pow_2_461 x_pow_2_461))
(define-fun x_pow_2_463 () F
  (ff.mul x_pow_2_462 x_pow_2_462))
(define-fun x_pow_2_464 () F
  (ff.mul x_pow_2_463 x_pow_2_463))
(define-fun x_pow_2_465 () F
  (ff.mul x_pow_2_464 x_pow_2_464))
(define-fun x_pow_2_466 () F
  (ff.mul x_pow_2_465 x_pow_2_465))
(define-fun x_pow_2_467 () F
  (ff.mul x_pow_2_466 x_pow_2_466))
(define-fun x_pow_2_468 () F
  (ff.mul x_pow_2_467 x_pow_2_467))
(define-fun x_pow_2_469 () F
  (ff.mul x_pow_2_468 x_pow_2_468))
(define-fun x_pow_2_470 () F
  (ff.mul x_pow_2_469 x_pow_2_469))
(define-fun x_pow_2_471 () F
  (ff.mul x_pow_2_470 x_pow_2_470))
(define-fun x_pow_2_472 () F
  (ff.mul x_pow_2_471 x_pow_2_471))
(define-fun x_pow_2_473 () F
  (ff.mul x_pow_2_472 x_pow_2_472))
(define-fun x_pow_2_474 () F
  (ff.mul x_pow_2_473 x_pow_2_473))
(define-fun x_pow_2_475 () F
  (ff.mul x_pow_2_474 x_pow_2_474))
(define-fun x_pow_2_476 () F
  (ff.mul x_pow_2_475 x_pow_2_475))
(define-fun x_pow_2_477 () F
  (ff.mul x_pow_2_476 x_pow_2_476))
(define-fun x_pow_2_478 () F
  (ff.mul x_pow_2_477 x_pow_2_477))
(define-fun x_pow_2_479 () F
  (ff.mul x_pow_2_478 x_pow_2_478))
(define-fun x_pow_2_480 () F
  (ff.mul x_pow_2_479 x_pow_2_479))
(define-fun x_pow_2_481 () F
  (ff.mul x_pow_2_480 x_pow_2_480))
(define-fun x_pow_2_482 () F
  (ff.mul x_pow_2_481 x_pow_2_481))
(define-fun x_pow_2_483 () F
  (ff.mul x_pow_2_482 x_pow_2_482))
(define-fun x_pow_2_484 () F
  (ff.mul x_pow_2_483 x_pow_2_483))
(define-fun x_pow_2_485 () F
  (ff.mul x_pow_2_484 x_pow_2_484))
(define-fun x_pow_2_486 () F
  (ff.mul x_pow_2_485 x_pow_2_485))
(define-fun x_pow_2_487 () F
  (ff.mul x_pow_2_486 x_pow_2_486))
(define-fun x_pow_2_488 () F
  (ff.mul x_pow_2_487 x_pow_2_487))
(define-fun x_pow_2_489 () F
  (ff.mul x_pow_2_488 x_pow_2_488))
(define-fun x_pow_2_490 () F
  (ff.mul x_pow_2_489 x_pow_2_489))
(define-fun x_pow_2_491 () F
  (ff.mul x_pow_2_490 x_pow_2_490))
(define-fun x_pow_2_492 () F
  (ff.mul x_pow_2_491 x_pow_2_491))
(define-fun x_pow_2_493 () F
  (ff.mul x_pow_2_492 x_pow_2_492))
(define-fun x_pow_2_494 () F
  (ff.mul x_pow_2_493 x_pow_2_493))
(define-fun x_pow_2_495 () F
  (ff.mul x_pow_2_494 x_pow_2_494))
(define-fun x_pow_2_496 () F
  (ff.mul x_pow_2_495 x_pow_2_495))
(define-fun x_pow_2_497 () F
  (ff.mul x_pow_2_496 x_pow_2_496))
(define-fun x_pow_2_498 () F
  (ff.mul x_pow_2_497 x_pow_2_497))
(define-fun x_pow_2_499 () F
  (ff.mul x_pow_2_498 x_pow_2_498))
(define-fun x_pow_2_500 () F
  (ff.mul x_pow_2_499 x_pow_2_499))
(define-fun x_pow_2_501 () F
  (ff.mul x_pow_2_500 x_pow_2_500))
(define-fun x_pow_2_502 () F
  (ff.mul x_pow_2_501 x_pow_2_501))
(define-fun x_pow_2_503 () F
  (ff.mul x_pow_2_502 x_pow_2_502))
(define-fun x_pow_2_504 () F
  (ff.mul x_pow_2_503 x_pow_2_503))
(define-fun x_pow_2_505 () F
  (ff.mul x_pow_2_504 x_pow_2_504))
(define-fun x_pow_2_506 () F
  (ff.mul x_pow_2_505 x_pow_2_505))
(define-fun x_pow_2_507 () F
  (ff.mul x_pow_2_506 x_pow_2_506))

(define-fun x_pow_q () F
  (ff.mul
    x_pow_2_253
    x_pow_2_252
    x_pow_2_246
    x_pow_2_245
    x_pow_2_242
    x_pow_2_238
    x_pow_2_235
    x_pow_2_234
    x_pow_2_233
    x_pow_2_230
    x_pow_2_229
    x_pow_2_228
    x_pow_2_225
    x_pow_2_223
    x_pow_2_222
    x_pow_2_221
    x_pow_2_216
    x_pow_2_213
    x_pow_2_212
    x_pow_2_208
    x_pow_2_207
    x_pow_2_205
    x_pow_2_197
    x_pow_2_195
    x_pow_2_192
    x_pow_2_191
    x_pow_2_189
    x_pow_2_188
    x_pow_2_187
    x_pow_2_182
    x_pow_2_180
    x_pow_2_174
    x_pow_2_170
    x_pow_2_168
    x_pow_2_167
    x_pow_2_165
    x_pow_2_164
    x_pow_2_162
    x_pow_2_161
    x_pow_2_159
    x_pow_2_152
    x_pow_2_151
    x_pow_2_144
    x_pow_2_142
    x_pow_2_140
    x_pow_2_139
    x_pow_2_134
    x_pow_2_132
    x_pow_2_131
    x_pow_2_130
    x_pow_2_128
    x_pow_2_127
    x_pow_2_124
    x_pow_2_122
    x_pow_2_121
    x_pow_2_120
    x_pow_2_119
    x_pow_2_112
    x_pow_2_110
    x_pow_2_109
    x_pow_2_107
    x_pow_2_105
    x_pow_2_103
    x_pow_2_100
    x_pow_2_96
    x_pow_2_94
    x_pow_2_93
    x_pow_2_91
    x_pow_2_86
    x_pow_2_85
    x_pow_2_84
    x_pow_2_80
    x_pow_2_79
    x_pow_2_78
    x_pow_2_75
    x_pow_2_73
    x_pow_2_71
    x_pow_2_67
    x_pow_2_66
    x_pow_2_64
    x_pow_2_61
    x_pow_2_60
    x_pow_2_59
    x_pow_2_58
    x_pow_2_53
    x_pow_2_47
    x_pow_2_43
    x_pow_2_42
    x_pow_2_36
    x_pow_2_34
    x_pow_2_33
    x_pow_2_31
    x_pow_2_30
    x_pow_2_28
    x_pow_2_27
    x_pow_2_22
    x_pow_2_21
    x_pow_2_20
    x_pow_2_19
    x_pow_2_18
    x_pow_2_15
    x_pow_2_14
    x_pow_2_13
    x_pow_2_12
    x_pow_2_11
    x_pow_2_10
    x_pow_2_8
    x_pow_2_6
    x_pow_2_2
    x_pow_2_1
    x_pow_2_0))

(define-fun x_pow_q_squared () F
  (ff.mul
    x_pow_2_507
    x_pow_2_504
    x_pow_2_501
    x_pow_2_498
    x_pow_2_496
    x_pow_2_495
    x_pow_2_494
    x_pow_2_490
    x_pow_2_487
    x_pow_2_485
    x_pow_2_484
    x_pow_2_483
    x_pow_2_478
    x_pow_2_477
    x_pow_2_476
    x_pow_2_474
    x_pow_2_473
    x_pow_2_469
    x_pow_2_468
    x_pow_2_467
    x_pow_2_466
    x_pow_2_463
    x_pow_2_461
    x_pow_2_460
    x_pow_2_459
    x_pow_2_458
    x_pow_2_457
    x_pow_2_456
    x_pow_2_455
    x_pow_2_452
    x_pow_2_451
    x_pow_2_450
    x_pow_2_446
    x_pow_2_444
    x_pow_2_443
    x_pow_2_440
    x_pow_2_439
    x_pow_2_436
    x_pow_2_435
    x_pow_2_433
    x_pow_2_430
    x_pow_2_429
    x_pow_2_427
    x_pow_2_426
    x_pow_2_425
    x_pow_2_424
    x_pow_2_422
    x_pow_2_421
    x_pow_2_420
    x_pow_2_419
    x_pow_2_418
    x_pow_2_409
    x_pow_2_408
    x_pow_2_406
    x_pow_2_403
    x_pow_2_399
    x_pow_2_398
    x_pow_2_396
    x_pow_2_393
    x_pow_2_388
    x_pow_2_387
    x_pow_2_386
    x_pow_2_383
    x_pow_2_381
    x_pow_2_380
    x_pow_2_371
    x_pow_2_369
    x_pow_2_368
    x_pow_2_367
    x_pow_2_362
    x_pow_2_360
    x_pow_2_358
    x_pow_2_356
    x_pow_2_352
    x_pow_2_348
    x_pow_2_346
    x_pow_2_345
    x_pow_2_341
    x_pow_2_340
    x_pow_2_338
    x_pow_2_337
    x_pow_2_336
    x_pow_2_334
    x_pow_2_332
    x_pow_2_330
    x_pow_2_329
    x_pow_2_322
    x_pow_2_321
    x_pow_2_317
    x_pow_2_314
    x_pow_2_313
    x_pow_2_311
    x_pow_2_310
    x_pow_2_309
    x_pow_2_307
    x_pow_2_306
    x_pow_2_304
    x_pow_2_303
    x_pow_2_302
    x_pow_2_301
    x_pow_2_300
    x_pow_2_299
    x_pow_2_297
    x_pow_2_294
    x_pow_2_292
    x_pow_2_291
    x_pow_2_290
    x_pow_2_285
    x_pow_2_284
    x_pow_2_282
    x_pow_2_279
    x_pow_2_278
    x_pow_2_274
    x_pow_2_273
    x_pow_2_271
    x_pow_2_269
    x_pow_2_268
    x_pow_2_265
    x_pow_2_264
    x_pow_2_263
    x_pow_2_259
    x_pow_2_258
    x_pow_2_256
    x_pow_2_250
    x_pow_2_246
    x_pow_2_245
    x_pow_2_243
    x_pow_2_239
    x_pow_2_236
    x_pow_2_235
    x_pow_2_234
    x_pow_2_233
    x_pow_2_231
    x_pow_2_228
    x_pow_2_226
    x_pow_2_224
    x_pow_2_222
    x_pow_2_221
    x_pow_2_220
    x_pow_2_219
    x_pow_2_217
    x_pow_2_212
    x_pow_2_209
    x_pow_2_206
    x_pow_2_201
    x_pow_2_199
    x_pow_2_198
    x_pow_2_195
    x_pow_2_190
    x_pow_2_187
    x_pow_2_185
    x_pow_2_182
    x_pow_2_180
    x_pow_2_172
    x_pow_2_171
    x_pow_2_167
    x_pow_2_164
    x_pow_2_163
    x_pow_2_162
    x_pow_2_158
    x_pow_2_157
    x_pow_2_155
    x_pow_2_154
    x_pow_2_152
    x_pow_2_151
    x_pow_2_148
    x_pow_2_146
    x_pow_2_145
    x_pow_2_143
    x_pow_2_142
    x_pow_2_139
    x_pow_2_137
    x_pow_2_135
    x_pow_2_134
    x_pow_2_132
    x_pow_2_131
    x_pow_2_130
    x_pow_2_127
    x_pow_2_125
    x_pow_2_122
    x_pow_2_121
    x_pow_2_113
    x_pow_2_106
    x_pow_2_105
    x_pow_2_104
    x_pow_2_101
    x_pow_2_99
    x_pow_2_98
    x_pow_2_96
    x_pow_2_91
    x_pow_2_88
    x_pow_2_87
    x_pow_2_86
    x_pow_2_85
    x_pow_2_83
    x_pow_2_81
    x_pow_2_79
    x_pow_2_78
    x_pow_2_72
    x_pow_2_64
    x_pow_2_61
    x_pow_2_60
    x_pow_2_59
    x_pow_2_57
    x_pow_2_56
    x_pow_2_54
    x_pow_2_52
    x_pow_2_50
    x_pow_2_46
    x_pow_2_44
    x_pow_2_43
    x_pow_2_39
    x_pow_2_37
    x_pow_2_33
    x_pow_2_29
    x_pow_2_26
    x_pow_2_25
    x_pow_2_24
    x_pow_2_22
    x_pow_2_20
    x_pow_2_19
    x_pow_2_18
    x_pow_2_16
    x_pow_2_14
    x_pow_2_13
    x_pow_2_11
    x_pow_2_8
    x_pow_2_7
    x_pow_2_5
    x_pow_2_4
    x_pow_2_0))

; The assertions are inconsistent by the Frobenius identity.
(assert (= x_pow_q x))
(assert (not (= x_pow_q_squared x)))
(check-sat)
