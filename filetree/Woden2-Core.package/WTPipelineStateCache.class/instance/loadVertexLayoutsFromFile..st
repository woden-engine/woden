state loading
loadVertexLayoutsFromFile: aFileName
	| layoutsJson layout |
	layoutsJson := self readJsonFromFile: aFileName.
	layoutsJson keysAndValuesDo: [ :name :layoutDesc |
		layout := WTVertexLayout new.
		layout buffers: ((layoutDesc at: 'buffers') collect: [ :structureName |
			self structureNamed: structureName asSymbol
		]).
	
		vertexLayouts at: name asSymbol put: layout
	]
