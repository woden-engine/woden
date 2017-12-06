accessing
cameraSceneNode
	^ self camera ifNotNil: [:c | c asSceneNode]