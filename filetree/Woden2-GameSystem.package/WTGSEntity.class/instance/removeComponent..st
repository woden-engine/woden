adding
removeComponent: aComponent
	(components at: aComponent bucket ifAbsent: [ ^ self ]) remove: aComponent.
	aComponent removedFromEntity: self.
	numberOfComponents := numberOfComponents - 1.