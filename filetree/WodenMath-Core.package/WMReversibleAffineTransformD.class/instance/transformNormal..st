transformations
transformNormal: aNormal
	^ (inverseMatrix transposedTransformVector3: aNormal)