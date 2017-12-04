rendering
updateRigidBodyFromSceneNode: rigidBody
	| transform |
	rigidBody sceneNode ifNil: [ ^ self ].
	
	transform := physicsEngine convertWMTransform: rigidBody sceneNode transform.
	rigidBody handle first setTransform: transform.
	rigidBody handle second setTransform: transform.