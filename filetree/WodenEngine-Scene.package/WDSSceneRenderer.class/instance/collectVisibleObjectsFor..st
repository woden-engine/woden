rendering preparations
collectVisibleObjectsFor: camera
	visibleObjects removeAll.
	visibleLightSources removeAll.
	currentScene roots do: [ :r |
		self collectVisibleObjectsFor: camera from: r
	]
	