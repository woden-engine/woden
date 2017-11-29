coordinate systems
normalizedToLocal: aPosition depth: aDepth
	cameraFrustum ifNil: [ self updateCameraProjection ].
	^ (cameraFrustum localPoint: aPosition atDistance: aDepth) asWMVector3D