adding
addComponent: aComponent
	| componentsCollection |
	componentsCollection := components at: aComponent bucket ifAbsentPut: [ OrderedCollection new ].
	componentsCollection add: aComponent.
	aComponent addedToEntity: self.
	numberOfComponents := numberOfComponents + 1.