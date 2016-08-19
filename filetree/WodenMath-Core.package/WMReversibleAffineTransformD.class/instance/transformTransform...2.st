transformations
transformTransform: transform
	<argument: #transform type: #(WMReversibleAffineTransformD object)>
	^ self class new
		matrix: matrix * transform matrix inverseMatrix3: transform inverseMatrix * inverseMatrix;
		translation: self translation + (matrix transformVector3: transform translation);
		yourself