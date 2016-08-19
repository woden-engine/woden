arithmetic
inverse
	<var: #il2 type: #double>
	| il2 |
	il2 := 1.0 asNativeDouble / ((r*r) + (i*i) + (j*j) + (k*k)).
	^ self class r: r * il2 i: i negated * il2 j: j negated * il2 k: k negated * il2