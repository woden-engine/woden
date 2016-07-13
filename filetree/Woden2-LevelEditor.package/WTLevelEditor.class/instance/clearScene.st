initialization
clearScene
	scene := WTSScene for: engine.
	
	camera := WTSCamera new.
	scene add: camera.
