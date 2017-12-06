camera projection
worldRayAtWindowCoordinate: point
	| ray |
	frustum := self frustum.
	frustum leftBottomFar ifNil: [ ^ nil ].
	
	ray := frustum rayAtNormalizedPoint: point.
	^ ray transformedWith: sceneNode transform