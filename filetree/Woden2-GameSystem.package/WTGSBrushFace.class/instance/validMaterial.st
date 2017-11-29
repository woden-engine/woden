as yet unclassified
validMaterial
	materialCache ifNotNil: [ ^ materialCache ].
	^ materialCache := brush map loadMaterial: material.
	