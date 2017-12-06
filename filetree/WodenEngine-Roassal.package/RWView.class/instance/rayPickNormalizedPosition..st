ray casting
rayPickNormalizedPosition: aPoint
	| ray distanceElement |
	ray := camera worldRayAtWindowCoordinate: aPoint.
	ray ifNil: [ ^ self ].
	
	distanceElement := self rayCast: ray.
	^ distanceElement value ifNil: [ self ]
	