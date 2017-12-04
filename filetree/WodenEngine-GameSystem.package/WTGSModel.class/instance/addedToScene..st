adding
addedToScene: anScene
	(model isNil and: [ modelName isNotEmpty ]) ifTrue: [
		self loadAndSetModel
	]
