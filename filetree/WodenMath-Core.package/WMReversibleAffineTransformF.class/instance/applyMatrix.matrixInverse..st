transformation building
applyMatrix: extraMatrix matrixInverse: extraMatrixInverse
	<argument: #(extraMatrix extraMatrixInverse) type: #(WMMatrix3F object)>
	matrix := extraMatrix * matrix.
	inverseMatrix := inverseMatrix * extraMatrixInverse.
	translation := extraMatrix transformVector4: translation.
	inverseTranslation := extraMatrixInverse transformVector4: inverseTranslation"inverseMatrix transformVector4: translation negatedVec3."