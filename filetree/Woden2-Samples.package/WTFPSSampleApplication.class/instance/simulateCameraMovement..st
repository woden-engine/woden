as yet unclassified
simulateCameraMovement: delta
	| orientation |
	cameraAngle := cameraAngle + (cameraAngularVelocity * (cameraAngularSpeed * delta)).
	orientation := (WMMatrix3F yrot: cameraAngle y) * (WMMatrix3F xrot: cameraAngle x).

	camera transform
		orthonormal: orientation;
		translateBy: (orientation transformVector3: (cameraVelocity * (cameraSpeed * delta))).
