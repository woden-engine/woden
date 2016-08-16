rendering
convertWMMatrix3: matrix
	^ APHYMatrix3x3 new
		firstRow: (self convertWMVector3: matrix firstRow);
		secondRow: (self convertWMVector3: matrix secondRow);
		thirdRow: (self convertWMVector3: matrix thirdRow);
		yourself