rendering
validateCollisionShapeHandle: collisionShape
	(collisionShape handle isNil or: [ collisionShape handle isNull ]) ifTrue: [
		self buildCollisionShape: collisionShape
	].
	^ collisionShape handle