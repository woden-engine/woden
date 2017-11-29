as yet unclassified
planeTextureTransform: textureMatrix
	| vertex normal position normalAxis tangent bitangent uv |
	1 to: vertices size do: [ :vi |
		vertex := vertices at: vi.
		normal := vertex normal.
		position := vertex position.
		
		"Compute the predominant normal plane."
		normalAxis := self computeNormalAxis: normal.
		tangent := self tangentForAxis: normalAxis.
		bitangent := self bitangentForAxis: normalAxis.
		
		"Compute the new texcoord"
		uv := WMVector2F x: (tangent dot: position) y: (bitangent dot: position).
		vertex texcoord: (textureMatrix transformPosition2: uv).
		
		vertices at: vi put: vertex.
	]
