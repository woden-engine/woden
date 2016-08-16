scene
initializeScene

	"Create the scene."
	scene := WTSScene for: engine.
	scene backgroundColor: Color white.

	"Add the camera"
	camera := RWCamera new.
	camera translateByZ: 5.0.
	self addInternalElement: camera.
	self addCameraLight: Color lightGray.