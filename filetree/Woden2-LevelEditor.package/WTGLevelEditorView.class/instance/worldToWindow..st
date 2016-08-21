coordinate systems
worldToWindow: aPoint
	^ self normalizedToWindow: (cameraFrustum localToNormalized: (cameraTransform inverseTransformPosition3: aPoint) asWMVector3F)