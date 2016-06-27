as yet unclassified
scriptsUsed
	"
	model := WTModelImporter new
		importFromFileNamed: 'magnum_357.wmjson'.
	model combineSubmeshesWithMaterial: 'materials/demos/magnum.json'.
	FLSerializer serialize: model toFileNamed: 'magnum.fmdl'.
	
	model := WTModelImporter new
		importFromFileNamed: 'magnum_357_fps.wmjson'.
	model combineSubmeshesWithMaterial: 'materials/demos/magnum_fps.json'.
	FLSerializer serialize: model toFileNamed: 'magnum_fps.fmdl'.

	"