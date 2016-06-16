resource loading
performMaterialLoading: materialFileReference
	| materialData materialType materialClassName materialClass |
	materialData := NeoJSONReader fromString: materialFileReference contents.
	materialType := materialData at: 'type' ifAbsent: [
		self error: 'Material does not have a valid type.'
	].

	materialClassName := ('WT' , materialType , 'Material') asSymbol.
	materialClass := Smalltalk at: materialClassName ifAbsent: [ self error: 'Failed to find material class for material type ' , materialType ].
	self assert: materialClass isMaterialClass.
	^ (materialClass for: engine)
		parse: materialFileReference data: materialData;
		yourself