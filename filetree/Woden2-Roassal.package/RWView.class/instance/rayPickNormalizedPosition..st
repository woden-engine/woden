ray casting
rayPickNormalizedPosition: aPoint
	| ray distanceElement |
	ray := camera worldRayAtWindowCoordinate: aPoint.
	distanceElement := self rayCast: ray.
	^ distanceElement value ifNil: [ self ]
	