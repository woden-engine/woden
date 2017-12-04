loading
loadFromFileNamed: fileName
	fileName asFileReference readStreamDo: [ :in |
		in binary.
		self loadFrom: in
	]
	