as yet unclassified
computeTangentsBitangents
	| vertex normal tangent bitangent tangents bitangents scaleFactor |
	self finishSubmesh.
	tangents := SLVMNativeArray for: WMVector3F new: vertices size.
	bitangents := SLVMNativeArray for: WMVector3F new: vertices size.
	submeshes do: [ :sm | self computeTangentsBitangentsFor: sm tangents: tangents bitangents: bitangents ].
	
	1 to: vertices size do: [ :vi |
		vertex := (vertices at: vi).
		
		normal := vertex normal asWMVector3.
		tangent := tangents at: vi.
		bitangent := bitangents at: vi.
		
		"Gram schmidth orthogonalization"
		tangent := (tangent - (normal * (normal dot: tangent))) normalized.
		bitangent := (bitangent - (normal * (normal dot: bitangent)) - (tangent * (tangent dot: bitangent))) normalized.
		scaleFactor := (normal cross: tangent) dot: bitangent.
		vertex tangent4: (WMVector4F x: tangent x y: tangent y z: tangent z w: scaleFactor).
		
		vertices at: vi put: vertex.
	].
