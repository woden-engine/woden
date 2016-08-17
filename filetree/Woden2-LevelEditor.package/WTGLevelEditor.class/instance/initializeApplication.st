initialization
initializeApplication
	super initializeApplication.
	currentMaterialName := ''.
	self
		createThumbnailPaintCache;
		loadMaterialThumbDB;
		clearScene;
		initializeSceneRenderer.