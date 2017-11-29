vector-transform
transform: aPoint 
	^ ((matrix m11 * aPoint x) + (matrix m12 * aPoint y) + matrix m13) @
		((matrix m21 * aPoint x) + (matrix m22 * aPoint y) + matrix m23)