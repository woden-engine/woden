rendering
simulateCamera: camera time: delta
	| orientation newCameraAngle |
	newCameraAngle := cameraAngle + (cameraAngularVelocity * (cameraAngularSpeed * delta)).
	cameraObjectState == camera ifTrue: [ cameraAngle := newCameraAngle].
	orientation := (WMMatrix3F yrot: newCameraAngle y) * (WMMatrix3F xrot: newCameraAngle x).

	camera orthonormal: orientation.
	camera translateBy: (orientation transformVector3: cameraVelocity * (cameraSpeed * delta)).
