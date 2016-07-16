as yet unclassified
updateCameraStateForRendering
	self
		updateCameraProjection;
		updateGridTransform.
	camera transform: cameraTransform.