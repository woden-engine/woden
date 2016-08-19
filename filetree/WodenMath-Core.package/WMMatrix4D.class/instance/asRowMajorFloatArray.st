converting
asRowMajorFloatArray
	| result |
	result := FloatArray new: 16.
	result
		at: 1 put: m11;
		at: 2 put: m12;
		at: 3 put: m13;
		at: 4 put: m14;
		
		at: 5 put: m21;
		at: 6 put: m22;
		at: 7 put: m23;
		at: 8 put: m24;
		
		at: 9 put: m31;
		at: 10 put: m32;
		at: 11 put: m33;
		at: 12 put: m34;
		
		at: 13 put: m41;
		at: 14 put: m42;
		at: 15 put: m43;
		at: 16 put: m44.
	^ result