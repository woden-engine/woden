arithmetic
inverse
	<var: #il2 type: #double>
	| il2 |
	il2 := 1.0 asNativeDouble / ((r*r) + (i*i)).
	^ self class r: r * il2 i: i negated * il2