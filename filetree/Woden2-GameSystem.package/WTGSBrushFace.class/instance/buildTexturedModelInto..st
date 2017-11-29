rendering
buildTexturedModelInto: meshBuilder
	| positions position normal texcoord textureMatrix texcoord3 tangentAndBitangent tangent bitangent tangentScaleFactor tangent4 |
	meshBuilder
		currentColor: self currentTexturedColor asWMVector4F;
		material: self validMaterial;
		beginTriangles.
		
	positions := brush positions.
	normal := plane normal asWMVector3F.
	textureMatrix := textureTransform asMatrixForNormal: plane normal.
	tangentAndBitangent := textureTransform findTangents: plane normal.
	tangent := tangentAndBitangent first.
	bitangent := tangentAndBitangent second.
	tangentScaleFactor := (plane normal cross: tangent) dot: bitangent.
	tangent4 := WMVector4F x: tangent x y: tangent y z: tangent z w: tangentScaleFactor.
	
	indices do: [ :i |
		position := positions at: i + 1.
		texcoord3 := textureMatrix transformPosition3: position.
		texcoord := WMVector2F x: texcoord3 x y: texcoord3 y.
		meshBuilder addP: position asWMVector3F N: normal T4: tangent4 TC: texcoord.
	].

	3 to: indices size do:[ :i |
		meshBuilder addI1: 1 i2: i - 1 i3: i
	].
