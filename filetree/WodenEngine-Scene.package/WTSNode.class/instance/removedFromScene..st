adding
removedFromScene: Scene
	scene := nil.
	children do: [ :child | child removedFromScene: scene ].