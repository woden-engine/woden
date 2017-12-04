accessing
frontFaceWinding: newFrontFaceWinding
	frontFaceWinding ~= newFrontFaceWinding ifTrue: [ self changed ].
	frontFaceWinding := newFrontFaceWinding