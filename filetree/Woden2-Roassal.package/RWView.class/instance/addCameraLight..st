scene
addCameraLight: color
	cameraLight := WTSLightSource new directional.
	cameraLight state
		intensity: color asWMVector4F.
	camera sceneNode addChild: cameraLight.