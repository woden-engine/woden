accessing
primitiveType: newPrimitiveType
	primitiveType ~= newPrimitiveType ifTrue: [ self changed ].
	primitiveType := newPrimitiveType