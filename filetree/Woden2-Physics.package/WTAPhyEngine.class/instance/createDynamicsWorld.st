as yet unclassified
createDynamicsWorld
	| collisionConfiguration collisionDispatcher broadphase constraintSolver world |
	collisionConfiguration := handle createDefaultCollisionConfiguration.
	collisionDispatcher := handle createDefaultCollisionDispatcher: collisionConfiguration.

	broadphase := handle createDefaultBroadphase.
	constraintSolver := handle createDefaultConstraintSolver.

	world := handle createDynamicsWorld: collisionDispatcher broadphase: broadphase constraint_solver: 	constraintSolver collision_configuration: collisionConfiguration.
		
	^ WTAPhyDynamicsWorld new physicsEngine: self; handle: world; yourself