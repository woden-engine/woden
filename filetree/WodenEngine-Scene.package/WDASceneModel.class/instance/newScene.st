instance creation
newScene
	scene := WTSScene for: engine.

	camera := WTSCamera new.
	scene add: camera.
	^ scene