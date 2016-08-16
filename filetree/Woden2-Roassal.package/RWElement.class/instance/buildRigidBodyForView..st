physics
buildRigidBodyForView: aView
	| collisionShape |
	mass ifNil: [ ^ self ].
	collisionShape := shape buildCollisionShapeFor: self.
	rigidBody := WTRigidBody new
					sceneNode: sceneNode;
					mass: mass;
					shape: collisionShape.
	aView addRigidBody: rigidBody