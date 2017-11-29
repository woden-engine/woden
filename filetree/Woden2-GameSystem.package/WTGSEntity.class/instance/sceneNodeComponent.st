accessing
sceneNodeComponent
	^ (components at: #sceneNode ifAbsent: [ ^ nil ]) first