initialization
initializeApplication
	super initializeApplication.
	currentMaterialName := ''.
	faceSelectMode := false.
	self
		createThumbnailPaintCache;
		loadMaterialThumbDB;
		clearScene;
		createMap;
		initializeSceneRenderer.