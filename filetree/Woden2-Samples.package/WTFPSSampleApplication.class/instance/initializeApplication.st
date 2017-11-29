initialize
initializeApplication
	super initializeApplication.
	stereoMode := false.
	vrMode := false.
	scene := WTSScene for: engine.
	self initializeAthensSurfaces.
	self initializeSceneRenderer.
	self initializeCamera.
	self initializeSceneContent.