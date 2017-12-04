adding
addedToScene: aScene
	self assert: scene isNil.
	scene := aScene.
	self createSceneDependentData.
	children do: [ :child | child addedToScene: scene ].