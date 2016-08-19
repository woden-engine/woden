accessing
orthonormal: newMatrix translation: vector3
	<argument: #newMatrix type: #(WMMatrix3F object)>
	<argument: #vector3 type: #(WMVector3F object)>
	matrix := newMatrix.
	inverseMatrix := newMatrix transposed.
	translation x: vector3 x.
	translation y: vector3 y.
	translation z: vector3 z.
	inverseTranslation := inverseMatrix transformVector4: translation negatedVec3.
	