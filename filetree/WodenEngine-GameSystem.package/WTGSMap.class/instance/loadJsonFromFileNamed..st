as yet unclassified
loadJsonFromFileNamed: aFileName
	^ self loadFromJson: (NeoJSONReader fromString: aFileName asFileReference contents)