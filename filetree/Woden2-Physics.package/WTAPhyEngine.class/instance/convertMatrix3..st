rendering
convertMatrix3: matrix3
	| firstRow secondRow thirdRow |
	firstRow := matrix3 firstRow.
	secondRow := matrix3 secondRow.
	thirdRow := matrix3 thirdRow.
	^ WMMatrix3F
		m11: firstRow x m12: firstRow y m13: firstRow z 
		m21: secondRow x m22: secondRow y m23: secondRow z
		m31: thirdRow x m32: thirdRow y m33: thirdRow z