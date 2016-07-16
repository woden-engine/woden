adding
addedToScene: scene
	scene ifNil: [ ^ self ].
	entity sceneNodeComponent node renderable: self