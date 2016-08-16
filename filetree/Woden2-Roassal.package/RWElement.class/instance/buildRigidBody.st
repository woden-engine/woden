physics
buildRigidBody
	| collisionShape |
	mass ifNil: [ ^ self ].
	collisionShape := shape buildCollisionShapeFor: self.
	rigidBody := WDRigidBody new
					mass: mass;
					shape: collisionShape.
	sceneNode attach: rigidBody