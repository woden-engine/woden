as yet unclassified
resetCameraState
	cameraTransform := WMReversibleAffineTransformD new.
	
	cameraVelocity := WMVector3D new.
	cameraSpeed := 1.0.
	
	cameraAngle := WMVector3D new.
	cameraAngularVelocity := WMVector3D new.
	cameraAngularSpeed := 1.0.
