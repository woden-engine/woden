loading
tryToLoadFromFileNamed: fileName
	fileName asFileReference exists ifFalse: [ ^ self new ].
	^ self loadFromFileNamed: fileName