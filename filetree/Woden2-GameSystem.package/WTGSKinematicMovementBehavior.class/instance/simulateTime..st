map events
simulateTime: delta
	| spatialDesc |
	linearVelocity := linearAcceleration * delta + linearVelocity.
	angularVelocity := angularAcceleration * delta + angularVelocity.
	
	spatialDesc := entity spatialDescription.
	spatialDesc transform
		kinematicTranslateBy: linearVelocity * delta
		rotateByQuaternion: (WMQuaternionD vector3: angularVelocity * delta * 0.5) "TODO: Look this up"