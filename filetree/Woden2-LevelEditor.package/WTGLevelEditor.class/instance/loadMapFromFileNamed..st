actions
loadMapFromFileNamed: fileName
	| newMap |
	newMap := WTGSMap loadJsonFromFileNamed: fileName.
	newMap editorMode: true.
	mapFileName := fileName.
	map ifNotNil: [ map scene: nil ].
	map := newMap.
	map scene: scene.
	
	renderMode := #solid.