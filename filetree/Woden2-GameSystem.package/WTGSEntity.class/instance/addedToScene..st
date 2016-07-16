adding
addedToScene: anScene
	(components at: #sceneNode ifAbsent: [ ^ self ]) do: [ :comp | comp addedToScene: anScene ].
	(components at: #renderingModels ifAbsent: [ ^ self ]) do: [ :comp | comp addedToScene: anScene ].