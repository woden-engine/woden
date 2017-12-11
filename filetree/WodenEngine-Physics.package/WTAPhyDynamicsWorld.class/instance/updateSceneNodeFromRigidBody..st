rendering
updateSceneNodeFromRigidBody: rigidBody
	| motionState rawTransform |
	rigidBody sceneNode ifNil: [ ^ self ].
	
	motionState := rigidBody handle second.
	rawTransform := APHYTransform new.
	motionState getTransformInto: rawTransform.
	rigidBody sceneNode
		transform: (physicsEngine convertTransform: rawTransform)