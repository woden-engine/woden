converting
asWMReversibleAffineTransformF
	^ WMReversibleAffineTransformF new
		matrix: matrix asWMMatrix3F inverseMatrix3: inverseMatrix asWMMatrix3F;
		translation: self translation asWMVector3F