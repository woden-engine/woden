rendering
initializeCamera
	camera := WTSCamera new.
	scene add: camera.
	
	cameraVelocity := WMVector3F new.
	cameraSpeed := 1.0.
	
	cameraAngle := WMVector3F new.
	cameraAngularVelocity := WMVector3F new.
	cameraAngularSpeed := 1.0.
