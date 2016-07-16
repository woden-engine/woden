initialization
clearScene
	scene := WTSScene for: engine.
	scene backgroundColor: Color veryDarkGray.
	
	camera := WTSCamera new.
	camera transform translateByZ: 2.0.
	scene add: camera.

	levelViews doWithIndex: [ :view :index |
		view sceneCreated.
		(DefaultSettingsForViews at: index) value: view.
	].

	self createMap.