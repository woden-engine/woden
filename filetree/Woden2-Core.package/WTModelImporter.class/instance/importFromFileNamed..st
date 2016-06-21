as yet unclassified
importFromFileNamed: fileName
	^ self loadFrom: (NeoJSONReader fromString: fileName asFileReference contents)