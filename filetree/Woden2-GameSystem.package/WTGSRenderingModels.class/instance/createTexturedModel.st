rendering
createTexturedModel
	| brushFaces |
	texturedModelBuilder
		clear.
	
	brushFaces := OrderedCollection new.
	(entity components at: #modeling) select: #isBrush thenDo: [ :brush |
		brushFaces addAll: brush faces
	].

	brushFaces sort: [ :a :b | a material <= b material ].
	brushFaces do: [:face | face buildTexturedModelInto: texturedModelBuilder].

	(entity components at: #modeling) do: [ :model |
		model isBrush ifFalse: [ model buildTexturedModelInto: texturedModelBuilder ] 
	].
		
	texturedModel := texturedModelBuilder mesh.
	invalidTexturedModel := false.
	^ texturedModel