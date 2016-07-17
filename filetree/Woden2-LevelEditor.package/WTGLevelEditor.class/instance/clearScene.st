initialization
clearScene
	scene := WTSScene for: engine.
	scene backgroundColor: Color veryDarkGray.

	levelViews doWithIndex: [ :view :index |
		view sceneCreated.
		(DefaultSettingsForViews at: index) value: view.
	].

	self
		createSelectionBox;
		createSelectionBoxView;
		createMap.