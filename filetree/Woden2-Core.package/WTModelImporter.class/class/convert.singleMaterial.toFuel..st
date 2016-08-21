as yet unclassified
convert: modelFileName singleMaterial: materialName toFuel: fuelModel
	| model |
	model := self new importFromFileNamed: modelFileName.
	model combineSubmeshesWithMaterial: materialName.
	FLSerializer serialize: model toFileNamed: fuelModel