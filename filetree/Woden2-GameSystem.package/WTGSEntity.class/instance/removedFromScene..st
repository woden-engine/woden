adding
removedFromScene: anScene
	(components at: #sceneNode ifAbsent: [ ^ self ]) do: [ :comp | comp removedFromScene: anScene ].
	(components at: #renderingModels ifAbsent: [ ^ self ]) do: [ :comp | comp removedFromScene: anScene ].
	pointEntity ifTrue: [ self deletePointEntityNode ].