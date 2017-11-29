factory
updateApplication: deltaTime
	application ifNotNil: [ ^ application updateWithDeltaTime: deltaTime ].
	^ 0.0