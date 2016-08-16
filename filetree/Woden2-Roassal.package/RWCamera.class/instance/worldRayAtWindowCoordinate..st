camera projection
worldRayAtWindowCoordinate: point
	| ray |
	ray := frustum rayAtNormalizedPoint: point.
	^ ray transformedWith: sceneNode transform