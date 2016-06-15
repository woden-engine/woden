rendering
initializeApplication
	super initializeApplication.
	scene := WTSScene for: engine.
	self initializeSceneRenderer.
	self initializeCamera.
	self initializeSceneContent.