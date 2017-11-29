actions
open
	self fileOpenDialog: 'Open Level' extensions: #('json') callback: [ :fileName |
		fileName ifNotNil: [
			[ self loadMapFromFileNamed: fileName ] fork
		]
	] 