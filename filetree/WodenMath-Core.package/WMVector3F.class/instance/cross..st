arithmetic
cross: other
	<argument: #other type: #(SelfType object)>
	<returnType: #(SelfType object)>
	
	^ self class
		x: (y * other z) - (z * other y) 
		y: (z * other x) - (x * other z)
		z: (x * other y) - (y * other x)