actions
saveAs
	self fileSaveDialog: 'Save Level' extensions: #('json') callback: [ :fileName |
		fileName ifNotNil: [
			[ self saveMapToFileNamed: fileName ] fork
		]
	] 