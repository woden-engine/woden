converting
asColumnMajorFloatArray
	| result |
	result := FloatArray new: 4.
	result
		at: 1 put: m11;
		at: 2 put: m21;
		
		at: 3 put: m12;
		at: 4 put: m22.
		
	^ result