rendering preparations
tryToCollectLightSource: lightSource for: camera
	self flag: 'Check for the light source influence radius and distance to the camera'.

	visibleLightSources add: {lightSource . 0.0}