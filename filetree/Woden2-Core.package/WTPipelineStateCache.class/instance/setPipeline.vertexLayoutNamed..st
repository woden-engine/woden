pipeline state object building
setPipeline: builder vertexLayoutNamed: vertexLayoutName
	| vertexLayout |
	vertexLayout := vertexLayouts at: vertexLayoutName asSymbol ifAbsent: [ 
		self error: 'Unknown vertex layout ', vertexLayoutName printString.
	].

	builder setVertexLayout: vertexLayout handle.