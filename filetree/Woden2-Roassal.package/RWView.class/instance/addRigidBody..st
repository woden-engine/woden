physics
addRigidBody: rigidBody
	dynamicsWorld ifNotNil: [ dynamicsWorld addRigidBody: rigidBody ].
	rigidBodies add: rigidBody