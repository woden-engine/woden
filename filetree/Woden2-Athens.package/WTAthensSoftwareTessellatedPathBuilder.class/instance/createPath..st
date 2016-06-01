creating path
createPath: aBlock
	baseIndex := 0.
	subpathVertexCount := 0.
	closed := true.
	backend ifNil: [ backend := WTAthensBasicMeshPathBuilderBackend new. ].
	aBlock value: self.
	^ backend.