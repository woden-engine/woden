coordinate systems
depthAtCameraDistance: distance
	^ isPerspective
		ifTrue: [ (distance - PerspectiveNearDistance) / (PerspectiveFarDistance - PerspectiveNearDistance) ]
		ifFalse: [ (distance - OrthographicNearDistance) / (OrthographicFarDistance - OrthographicNearDistance) ]