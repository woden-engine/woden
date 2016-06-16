state loading
readJsonFromFile: fileName
	^ fileName asFileReference readStreamDo: [ :in | (NeoJSONReader on: in) next ]