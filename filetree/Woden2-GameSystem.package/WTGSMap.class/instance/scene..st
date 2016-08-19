accessing
scene: anObject
	scene ifNotNil: [
		self destroyPointEntityInstanceGroup
		entities do: [ :entity | entity removedFromScene: scene ]
	]. 
	scene := anObject.
	scene ifNotNil: [
		self createPointEntityInstanceGroup.
		entities do: [ :entity | entity addedToScene: scene ]
	]