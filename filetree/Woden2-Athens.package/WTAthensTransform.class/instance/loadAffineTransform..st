transformations
loadAffineTransform: anAthenTransform
	matrix
		m11: anAthenTransform sx asFloat; m12: anAthenTransform shx asFloat; m13: anAthenTransform x;
		m11: anAthenTransform shy asFloat; m12: anAthenTransform sy asFloat; m13: anAthenTransform y;
		m31: 0.0; m32: 0.0; m33: 0.0.