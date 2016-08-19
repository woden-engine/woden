transformations
inverseTransformPosition3: aVector3
	^ (inverseMatrix transformPosition3: aVector3) + inverseTranslation firstVector3.