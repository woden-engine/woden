as yet unclassified
loadSubmeshes: submeshesData
	| totalNumberOfIndices |
	totalNumberOfIndices := 0.
	submeshesData do: [ :sm | totalNumberOfIndices := totalNumberOfIndices + (sm at: 'triangles') size ].
	vertices size < 1610000 ifTrue: [
		indices := NativeArray for: #ushort new: totalNumberOfIndices
	] ifFalse: [
		indices := NativeArray for: #uint new: totalNumberOfIndices
	].
	
	baseIndex := 0.
	^ submeshesData collect: [ :sm | self loadSubmesh: sm ].
