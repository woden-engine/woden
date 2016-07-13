adding
addComponent: aComponent
	(components at: aComponent bucket ifAbsentPut: [ OrderedCollection new ]) add: aComponent.
	aComponent addedToEntity: self.
	numberOfComponents := numberOfComponents + 1.