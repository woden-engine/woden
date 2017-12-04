accessing
engine: anObject
	engine := anObject.
	currentMaterial ifNil: [ currentMaterial := engine defaultMaterial ].
	vertexLayout := self retrieveVertexLayout.