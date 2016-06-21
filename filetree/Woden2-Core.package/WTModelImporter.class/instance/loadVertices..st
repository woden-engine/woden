as yet unclassified
loadVertices: verticesData
	| positions normals texcoords tangents4 numberOfVertices vertex normal tangent bitangent |
	positions := verticesData at: 'positions' ifAbsent: [ self error: 'Position data is not present.' ].
	normals := verticesData at: 'normals' ifAbsent: [ nil ].
	texcoords := verticesData at: 'texcoords' ifAbsent: [ nil].
	tangents4 := verticesData at: 'tangents4' ifAbsent: [ nil ].
	
	numberOfVertices := positions size // 3.
	vertices := NativeArray for: WTGenericVertexF new: numberOfVertices.
	1 to: numberOfVertices do: [ :i |
		vertex := WTGenericVertexF new.
		vertex position: (WMVector3F x: (positions at: i*3 - 2) y: (positions at: i*3 - 1) z: (positions at: i*3)).
		
		vertex color: (WMVector4F x: 1.0 y: 1.0 z: 1.0 w: 1.0).
		
		texcoords ifNotNil: [ 
			vertex texcoord: (WMVector2F x: (texcoords at: i*2 - 1) y: (texcoords at: i*2)).
		].
	
		normals ifNotNil: [ 
			normal := (WMVector3F x: (normals at: i*3 - 2) y: (normals at: i*3 - 1) z: (normals at: i*3)).
			vertex normal: normal.
		].

		tangents4 ifNotNil: [
			tangent := (WMVector3F x: (tangents4 at: i*4 - 3) y: (tangents4 at: i*4 - 2) z: (tangents4 at: i*4 - 1)).
			bitangent := (normal cross: tangent) * (tangents4 at: i*4).
			vertex
				tangent: tangent;
				bitangent: bitangent.
		].
	
		vertices at: i put: vertex.
	].
