" Vim syntax file
" Language: Radiance functional language (CAL)
" Maintainer: Srichand Pendyala

if exists('b:current_syntax')
	finish
endif

syntax case match

" CAL comments use nestable braces rather than line comments.
syntax region radianceCalComment start=/{/ end=/}/ contains=radianceCalComment,@Spell fold
syntax sync fromstart

" Integers, decimal fractions, and scientific notation. A leading or trailing
" decimal point is valid (for example, .5 and 1.). Signs are operators.
syntax match radianceCalNumber /\%(^\|[^[:alnum:]_.`]\)\@<=\%([0-9]\+\%([.][0-9]*\)\?\|[.][0-9]\+\)\%([eE][+-]\?[0-9]\+\)\?\%($\|[^[:alnum:]_.`]\)\@=/

" Rcalc-style input and output channels.
syntax match radianceCalChannel /\$[0-9]\+\%($\|[^[:alnum:]_.`]\)\@=/

" Names begin with a letter. Back-quotes select local, enclosing, or global
" contexts; periods are ordinary name characters in CAL.
let s:cal_name = '\%(^\|[^A-Za-z0-9_.`]\)\@<=`\?[A-Za-z][A-Za-z0-9_.]*\%(`\%([A-Za-z][A-Za-z0-9_.]*\)\?\)*'

" Match general function calls and definitions before the more specific
" built-in groups below. Function parameters cannot themselves be calls.
execute 'syntax match radianceCalFunction /' . s:cal_name . '\ze\s*(/'
execute 'syntax match radianceCalFunctionDefinition /' . s:cal_name
	\ . '\ze\s*(\s*[^()]*)\s*[=:]/'
execute 'syntax match radianceCalDefinition /' . s:cal_name . '\ze\s*[=:]/'

" Functions provided by the CAL library, the Radiance renderer, rayinit.cal,
" rcalc, and pcomb. Keep these as keywords so function-valued arguments such
" as d1(sin, x) are highlighted as well as direct calls.
syntax keyword radianceCalBuiltinFunction
	\ if select min max sqrt sin cos tan asin acos atan atan2 floor ceil
	\ exp log log10 erf erfc j0 j1 jn y0 y1 yn rand hermite
	\ noise3 noise3x noise3y noise3z fnoise3 arg in
	\ D N P noise3a noise3b noise3c noise3d bound Acos Asin Atan2 Exp Sqrt
	\ and or not xor abs sgn sq inside frac mod tri linterp noop clip noneg
	\ red green blue grey clip_r clip_g clip_b clipgrey dot cross fade bezier
	\ bspline turbulence turbulencex turbulencey turbulencez unif2norm nrand
	\ Ldx Ldy Ldz
	\ ri gi bi li re ge be le pa Ox Oy Oz

" Constants and variables supplied by common CAL hosts. A CAL file may only
" use the subset exposed by the program that loads it.
syntax keyword radianceCalConstant
	\ PI DEGREE FTINY nfiles WE xmax ymax xres yres

syntax keyword radianceCalBuiltinVariable
	\ Dx Dy Dz Nx Ny Nz Px Py Pz T Ts Rdot S
	\ Tx Ty Tz Ix Iy Iz Jx Jy Jz Kx Ky Kz
	\ Lu Lv NxP NyP NzP RdotP CrP CgP CbP DxA DyA DzA
	\ AC A1 A2 A3 A4 A5 A6 A7 A8 A9 A10
	\ Idx Idy Idz U V
	\ cond recno outno ro go bo lo x y

syntax match radianceCalAssignmentOperator /[=:]/
syntax match radianceCalOperator /[+*\/^,-]/
syntax match radianceCalDelimiter /[();]/

highlight default link radianceCalComment Comment
highlight default link radianceCalNumber Number
highlight default link radianceCalChannel Special
highlight default link radianceCalFunction Function
highlight default link radianceCalFunctionDefinition Function
highlight default link radianceCalDefinition Identifier
highlight default link radianceCalBuiltinFunction Function
highlight default link radianceCalConstant Constant
highlight default link radianceCalBuiltinVariable Special
highlight default link radianceCalAssignmentOperator StorageClass
highlight default link radianceCalOperator Operator
highlight default link radianceCalDelimiter Delimiter

let b:current_syntax = 'radiancecal'

unlet s:cal_name
