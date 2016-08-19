converting
asRowMajorFloatArray
	| result |
	result := FloatArray new: 9.
	result
		at: 1 put: m11;
		at: 2 put: m12;
		at: 3 put: m13;
		
		at: 4 put: m21;
		at: 5 put: m22;
		at: 6 put: m23;
		
		at: 7 put: m31;
		at: 8 put: m32;
		at: 9 put: m33.
	^ result