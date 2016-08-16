scene
addCameraLight: color
	cameraLight := WTSLightSource new directional.
	cameraLight transform rotateDegreesOnY: 180.0.
	cameraLight state
		intensity: color asWMVector4F.
	camera sceneNode addChild: cameraLight.