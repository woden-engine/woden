initialization
addedAssetSearchPath: searchPath
	| fileRef |
	fileRef := searchPath / 'pipeline-states' / 'states.json'.
	fileRef exists ifTrue: [ 
		self loadStatesFromFile: fileRef
	]