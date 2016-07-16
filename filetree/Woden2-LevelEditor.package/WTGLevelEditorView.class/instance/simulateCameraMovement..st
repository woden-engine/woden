as yet unclassified
simulateCameraMovement: delta
	| orientation |
	cameraAngle := cameraAngle + (cameraAngularVelocity * (cameraAngularSpeed * delta)).
	orientation := (WMMatrix3D yrot: cameraAngle y) * (WMMatrix3D xrot: cameraAngle x).

	cameraTransform
		orthonormal: orientation;
		translateBy: (orientation transformVector3: (cameraVelocity * (cameraSpeed * delta))).
