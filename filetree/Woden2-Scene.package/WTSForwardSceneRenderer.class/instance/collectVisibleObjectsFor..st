visibility
collectVisibleObjectsFor: camera
	visibleObjects removeAll.
	visibleLightSources removeAll.
	scene roots do: [ :r |
		self collectVisibleObjectsFor: camera from: r
	]
	