as yet unclassified
computeTangentsBitangents
	| vertex normal tangent bitangent |
	self finishSubmesh.
	1 to: vertices size do: [ :vi |
		vertices at: vi put: 
		((vertices at: vi)
			tangent: WMVector3F new;
			bitangent: WMVector3F new;
			yourself)
	].

	submeshes do: [ :sm | self computeTangentsBitangentsFor: sm ].
	
	1 to: vertices size do: [ :vi |
		vertex := (vertices at: vi).
		
		normal := vertex normal.
		tangent := vertex tangent.
		bitangent := vertex bitangent.
		
		"Gram schmidth orthogonalization"
		tangent := (tangent - (normal * (normal dot: tangent))) normalized.
		bitangent := (bitangent - (normal * (normal dot: bitangent)) - (tangent * (tangent dot: bitangent))) normalized.

		vertex tangent: tangent.
		vertex bitangent: bitangent.
		
		vertices at: vi put: vertex.
	].
