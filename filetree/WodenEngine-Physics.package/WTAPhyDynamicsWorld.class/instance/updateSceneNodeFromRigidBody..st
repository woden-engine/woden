rendering
updateSceneNodeFromRigidBody: rigidBody
	| motionState |
	rigidBody sceneNode ifNil: [ ^ self ].
	
	motionState := rigidBody handle second.
	rigidBody sceneNode
		transform: (physicsEngine convertTransform: motionState getTransform)