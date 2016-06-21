as yet unclassified
scriptsUsed
	"
	model := WTModelImporter new
		importFromFileNamed: 'magnum_357.wmjson'.
	model combineSubmeshesWithMaterial: 'materials/demos/magnum.json'.
	FLSerializer serialize: model toFileNamed: 'magnum.fmdl'.
	"