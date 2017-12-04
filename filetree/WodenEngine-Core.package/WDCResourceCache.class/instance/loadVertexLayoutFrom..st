resource loading
loadVertexLayoutFrom: aVertexClass
	| layout |
	layout := aVertexClass asWodenVertexLayout.
	self buildVertexLayout: layout.
	^ layout