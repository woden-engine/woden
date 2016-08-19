adding
addedToScene: anScene
	(components at: #sceneNode ifAbsent: [ #() ]) do: [ :comp | comp addedToScene: anScene ].
	(components at: #renderingModels ifAbsent: [ #() ]) do: [ :comp | comp addedToScene: anScene ].
	pointEntity ifTrue: [ self createPointEntityNode ].