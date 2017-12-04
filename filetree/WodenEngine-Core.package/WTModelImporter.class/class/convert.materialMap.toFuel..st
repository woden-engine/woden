as yet unclassified
convert: modelFileName materialMap: materialMapOrArray toFuel: fuelModel
	| model materialMap |
	model := self new importFromFileNamed: modelFileName.
	materialMap := materialMapOrArray.
	materialMap isArray ifTrue: [
		materialMap := Dictionary newFrom: materialMap.
	].

	model mapMaterials: materialMap.
	FLSerializer serialize: model toFileNamed: fuelModel