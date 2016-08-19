arithmetic
multWithQuaternion: other
	<argument: #other type: #(SelfType object)>
	<returnType: #(SelfType object)>
	^ self class
		r: (r * other r) - (i * other i) - (j * other j) - (k * other k)
		i: (r * other i) + (i * other r) + (j * other k) - (k * other j)
		j: (r * other j) - (i * other k) + (j * other r) + (k * other i)
		k: (r * other k) + (i * other j) - (j * other i) + (k * other r)