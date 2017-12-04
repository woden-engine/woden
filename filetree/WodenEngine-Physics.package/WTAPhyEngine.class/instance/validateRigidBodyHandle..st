rendering
validateRigidBodyHandle: rigidBody
	(rigidBody handle isNil or: [ rigidBody handle isNull ]) ifTrue: [
		self buildRigidBody: rigidBody
	].
	^ rigidBody handle