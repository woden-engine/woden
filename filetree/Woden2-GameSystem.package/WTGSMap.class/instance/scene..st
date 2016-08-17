accessing
scene: anObject
	scene ifNotNil: [
		entities do: [ :entity | entity removedFromScene: scene ]
	]. 
	scene := anObject.
	scene ifNotNil: [
		entities do: [ :entity | entity addedToScene: scene ]
	]