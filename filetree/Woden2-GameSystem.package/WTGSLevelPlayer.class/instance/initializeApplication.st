rendering
initializeApplication
	super initializeApplication.
	scene := WTSScene for: engine.
	self initializeAthensSurfaces.
	self initializeSceneRenderer.
	self initializeCamera.