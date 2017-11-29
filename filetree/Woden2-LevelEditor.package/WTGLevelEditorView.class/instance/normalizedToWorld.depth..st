coordinate systems
normalizedToWorld: aPosition depth: aDepth
	cameraFrustum ifNil: [ self updateCameraProjection ].
	^ cameraTransform transformPosition3: (cameraFrustum localPoint: aPosition atDistance: aDepth) asWMVector3D