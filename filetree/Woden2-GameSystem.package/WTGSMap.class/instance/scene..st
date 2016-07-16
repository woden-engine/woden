accessing
scene: anObject
	scene := anObject.
	entities do: [ :entity | entity addedToScene: scene ]