actions
save
	mapFileName ifNil: [ ^ self saveAs ].
	self saveMapToFileNamed: mapFileName.
	