as yet unclassified
loadFrom: jsonData
	| boundingBox |
	self loadVertices: (jsonData at: 'vertices').
	submeshes := self loadSubmeshes: (jsonData at: 'submeshes').
	boundingBox := self loadBoundingBox: (jsonData at: 'boundingBox').
	^ WTModel new
		vertices: vertices;
		indices: indices;
		submeshes: submeshes;
		boundingBox: boundingBox
		yourself.