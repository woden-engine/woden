arithmetic
inverse
	<var: #il2 type: #float>
	| il2 |
	il2 := 1.0 asNativeFloat / ((r*r) + (i*i)).
	^ self class r: r * il2 i: i negated * il2