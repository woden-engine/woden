initialization
clearScene
	scene := WTSScene for: engine.
	scene backgroundColor: Color veryDarkGray.

	self
		createSelectionBox.
		
	levelViews doWithIndex: [ :view :index |
		view sceneCreated.
		(DefaultSettingsForViews at: index) value: view.
	].