initialization
initializeApplication
	super initializeApplication.
	currentMaterialName := ''.
	faceSelectMode := false.
	gridSize := 1.0.
	self
		createThumbnailPaintCache;
		loadMaterialThumbDB;
		clearScene;
		createMap;
		initializeSceneRenderer.