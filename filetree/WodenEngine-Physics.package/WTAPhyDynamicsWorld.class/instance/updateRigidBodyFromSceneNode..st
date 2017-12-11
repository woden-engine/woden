rendering
updateRigidBodyFromSceneNode: rigidBody
	| transform |
	rigidBody sceneNode ifNil: [ ^ self ].
	
	transform := physicsEngine convertWMTransform: rigidBody sceneNode transform.
	rigidBody handle first setTransformFrom: transform.
	rigidBody handle second setTransformFrom: transform.