selection
rayAtWindowCoord: coord
	| ray |
	cameraFrustum ifNil: [ self updateCameraProjection ].
	ray := cameraFrustum rayAtNormalizedPoint: (self normalizedPosition: coord).
	^ ray asWMRayD transformedWith: cameraTransform