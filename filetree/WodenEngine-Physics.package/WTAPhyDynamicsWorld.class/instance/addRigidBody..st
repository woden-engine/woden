adding
addRigidBody: rigidBody
	| rigidBodyHandle |
	rigidBodyHandle := physicsEngine validateRigidBodyHandle: rigidBody.
	handle addRigidBody: rigidBodyHandle first.
	rigidBody mass = 0.0 ifTrue: [
		kinematicObjects add: rigidBody.
	] ifFalse: [
		rigidBodies add: rigidBody.
	].
	
	rigidBody sceneNode ifNotNil: [
		rigidBody sceneNode onStateChangeDo: [ :body |
			onSimulation ifFalse: [ self updateRigidBodyFromSceneNode: rigidBody ]
		].
	
		self updateRigidBodyFromSceneNode: rigidBody
	].
