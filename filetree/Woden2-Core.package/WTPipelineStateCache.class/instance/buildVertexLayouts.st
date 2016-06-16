abstract gpu baking
buildVertexLayouts
	vertexLayouts valuesDo: [ :vertexLayout | self buildVertexLayout: vertexLayout ]