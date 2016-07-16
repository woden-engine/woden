as yet unclassified
createCamera
	| scene |
	scene := self scene.
	
	camera := WTSCamera new.
	scene add: camera.
	
	self resetCameraState.
