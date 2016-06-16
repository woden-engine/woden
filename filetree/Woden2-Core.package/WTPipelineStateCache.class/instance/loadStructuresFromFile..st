state loading
loadStructuresFromFile: aFileName
	| structuresJson |
	structuresJson := self readJsonFromFile: aFileName.
	structuresJson keysAndValuesDo: [ :name :structureDesc | self loadNamed: name structure: structureDesc ]