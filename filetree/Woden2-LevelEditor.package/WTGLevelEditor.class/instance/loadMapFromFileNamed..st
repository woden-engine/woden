actions
loadMapFromFileNamed: fileName
	| newMap |
	newMap := WTGSMap loadJsonFromFileNamed: 'testMap.json'.
	map ifNotNil: [ map scene: nil ].
	map := newMap.
	map scene: scene.
	
	renderMode := #solid.