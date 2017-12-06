physics
withPhysics
	dynamicsWorld := WTPhysicsEngine current createDynamicsWorld.
	dynamicsWorld gravity: (WMVector3F x: 0.0 y: -9.8 z: 0.0).
	dynamicsWorld addRigidBodies: rigidBodies.
