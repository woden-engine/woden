actions
loadMapFromFileNamed: fileName
	| newMap |
	newMap := WTGSMap loadJsonFromFileNamed: fileName.
	mapFileName := fileName.
	map ifNotNil: [ map scene: nil ].
	map := newMap.
	map scene: scene.
	
	renderMode := #solid.