accessing
material: anObject
	material := anObject.
	self assert: material isNotNil.
	materialCache := nil.
	self invalidateTexturedModel