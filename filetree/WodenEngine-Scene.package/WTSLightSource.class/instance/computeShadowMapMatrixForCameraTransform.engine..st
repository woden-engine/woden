as yet unclassified
computeShadowMapMatrixForCameraTransform: cameraTransform engine: engine
	shadowProjectionMatrix := (WMMatrix4F reverseDepthPerspectiveFovY: outerSpotCutoff * 2.0 aspect: 1.0 near: 0.01 far: 30.0 invertedY: engine projectionInvertedY).

	^ shadowProjectionMatrix * renderTransform inverseMatrix4 * cameraTransform matrix4