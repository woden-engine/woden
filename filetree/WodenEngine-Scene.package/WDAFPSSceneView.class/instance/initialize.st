initialization
initialize
	super initialize.

	cameraVelocity := WMVector3F new.
	cameraSpeed := 1.0.
	
	cameraAngle := WMVector3F new.
	cameraAngularVelocity := WMVector3F new.
	cameraAngularSpeed := 1.0.