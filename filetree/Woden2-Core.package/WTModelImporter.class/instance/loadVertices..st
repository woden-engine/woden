as yet unclassified
loadVertices: verticesData
	| positions normals texcoords tangents4 numberOfVertices vertex normal boneIndices boneWeights isSkinned vertexClass weights den |
	positions := verticesData at: 'positions' ifAbsent: [ self error: 'Position data is not present.' ].
	normals := verticesData at: 'normals' ifAbsent: [ nil ].
	texcoords := verticesData at: 'texcoords' ifAbsent: [ nil].
	tangents4 := verticesData at: 'tangents4' ifAbsent: [ nil ].
	boneIndices := verticesData at: 'boneIndices' ifAbsent: [ nil ].
	boneWeights := verticesData at: 'boneWeights' ifAbsent: [ nil ].
	
	isSkinned := boneIndices isNotNil and: [ boneWeights isNotNil ].
	vertexClass := isSkinned ifTrue: [ WTSkinnedGenericVertexF ] ifFalse: [ WTGenericVertexF ].
	numberOfVertices := positions size // 3.
	vertices := SLVMNativeArray for: vertexClass new: numberOfVertices.
	1 to: numberOfVertices do: [ :i |
		vertex := vertexClass new.
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
			vertex
				tangent4: (WMVector4F x: (tangents4 at: i*4 - 3) y: (tangents4 at: i*4 - 2) z: (tangents4 at: i*4 - 1) w: (tangents4 at: i*4))
		].
	
		isSkinned ifTrue: [
			vertex boneIndices: (WMVector4US
				x: (boneIndices at: i*4 - 3)
				y: (boneIndices at: i*4 - 2)
				z: (boneIndices at: i*4 - 1)
				w: (boneIndices at: i*4)).
			weights := (WMVector4F
				x: (boneWeights at: i*4 - 3)
				y: (boneWeights at: i*4 - 2)
				z: (boneWeights at: i*4 - 1)
				w: (boneWeights at: i*4)).
			den := weights x + weights y + weights z + weights w.
			(den closeTo: 0.0) ifFalse: [ weights := weights / den ].
			vertex boneWeights: weights.
		].
	
		vertices at: i put: vertex.
	].
