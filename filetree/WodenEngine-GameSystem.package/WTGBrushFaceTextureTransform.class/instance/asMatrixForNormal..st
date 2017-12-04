converting
asMatrixForNormal: aNormal
	| tangents u v|
	tangents := self findTangents: aNormal.
	u := tangents first.
	v := tangents second.
	
	^ self textureMatrix4 * (WMMatrix4D newFrom: { 
		u x . u y . u z . 0.0 .
		v x . v y . v z . 0.0 .
		0.0 . 0.0 . 1.0 . 0.0 .
		0.0 . 0.0 . 0.0 . 1.0
	 }).