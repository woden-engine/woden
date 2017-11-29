adding
removedFromScene: anScene
	(components at: #sceneNode ifAbsent: [ #() ]) do: [ :comp | comp removedFromScene: anScene ].
	(components at: #renderingModels ifAbsent: [ #() ]) do: [ :comp | comp removedFromScene: anScene ].
	pointEntity ifTrue: [ self deletePointEntityNode ].