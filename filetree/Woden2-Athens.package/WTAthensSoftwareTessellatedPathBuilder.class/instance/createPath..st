creating path
createPath: aBlock
	baseIndex := 0.
	closed := true.
	backend ifNil: [ backend := WTAthensMeshPathBuilderBackend new. ].
	aBlock value: self.
	^ backend.