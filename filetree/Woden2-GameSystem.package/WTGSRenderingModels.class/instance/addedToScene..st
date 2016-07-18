adding
addedToScene: scene
	| nodeComponent |
	scene ifNil: [ ^ self ].
	nodeComponent := entity sceneNodeComponent.
	nodeComponent
		addedToScene: scene.
	nodeComponent node renderable: self