as yet unclassified
loadSubmesh: submeshData
	| triangles numberOfTriangles submesh |
	triangles := submeshData at: 'triangles'.
	numberOfTriangles := triangles size.
	submesh := WTModelSubmesh new
		firstIndex: baseIndex;
		indexCount: numberOfTriangles;
		primitiveType: AGPU_TRIANGLES;
		material: (submeshData at: 'material');
		yourself.
	
	1 to: numberOfTriangles do: [ :i |
		indices at: baseIndex + i put: (triangles at: i)
	].

	baseIndex := baseIndex + triangles size.
	^ submesh