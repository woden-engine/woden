resource loading
vertexLayoutFor: aVertexClass
	^ vertexLayouts at: aVertexClass ifAbsentPut: [ self loadVertexLayoutFrom: aVertexClass ]