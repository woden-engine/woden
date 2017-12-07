rendering process stages
createScreenGrid
	| steps vertices destIndex rowIndex nextRowIndex indices i1 i2 i3 i4 |
	screenGridVertexBuffer ifNotNil: [ ^ self ].
	
	steps := 33.
	"Create the vertices"
	vertices := SLVMNativeArray for: WTCompositionVertexF new: steps*steps.
	destIndex := 1.
	-1.0 to: 1.0 by: (2.0 / (steps - 1)) do: [ :y |
		-1.0 to: 1.0 by: (2.0 / (steps - 1)) do: [ :x |
			vertices at: destIndex put: (WTCompositionVertexF new position: (WMVector2F x: x y: y)).
			destIndex := destIndex + 1
		].
	].

	"Create the indices"
	rowIndex := 0.
	nextRowIndex := rowIndex + steps.
	indices := SLVMNativeOrderedCollection for: #short.
	1 to: steps - 1 do: [ :r |
		0 to: steps - 2 do: [ :x |
			i1 := rowIndex + x.
			i2 := rowIndex + x + 1.
			i3 := nextRowIndex + x.
			i4 := nextRowIndex + x + 1.
			indices add: i1; add: i2; add: i3.
			indices add: i2; add: i4; add: i3.
		].

		rowIndex := rowIndex + steps.
		nextRowIndex := nextRowIndex + steps.
	].

	"Upload the buffers"
	screenGridVertexBuffer := engine createVertex: WTCompositionVertexF structureSize elements: vertices size immutableBuffer: vertices asByteArray.
	screenGridIndexBuffer := engine createIndex: 2 elements: indices size immutableBuffer: indices asByteArray.
	screenGridIndexCount := indices size.
	
	screenGridVertexBinding := engine createVertexBindingForLayout: (engine vertexLayoutFor: WTCompositionVertexF).
	screenGridVertexBinding vertexBuffers: { screenGridVertexBuffer }