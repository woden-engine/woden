adding
addedToScene: scene
	| nodeComponent |
	scene ifNil: [ ^ self ].
	nodeComponent := entity sceneNodeComponent.
	nodeComponent node renderable: self