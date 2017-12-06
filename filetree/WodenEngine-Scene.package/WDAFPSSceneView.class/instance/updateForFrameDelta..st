rendering process stages
updateForFrameDelta: delta
	| orientation |
	cameraAngle := cameraAngle + (cameraAngularVelocity * (cameraAngularSpeed * delta)).
	orientation := (WMMatrix3F yrot: cameraAngle y) * (WMMatrix3F xrot: cameraAngle x).

	"vrSensorReader ifNotNil: [ 
		sensorState := vrSensorReader sensorState.
		orientation := sensorState orientation asWMMatrix3F * orientation.
		camera vrTransform translation: sensorState translation
	]."

	self camera transform
		orthonormal: orientation;
		translateBy: (orientation transformVector3: (cameraVelocity * (cameraSpeed * delta))).
