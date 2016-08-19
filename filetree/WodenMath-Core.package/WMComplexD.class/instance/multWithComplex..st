arithmetic
multWithComplex: other
	<argument: #other type: #(SelfType object)>
	<returnType: #(SelfType object)>
	^ self class r: (r * other r) - (i * other i) i: (r * other i) + (i * other r)