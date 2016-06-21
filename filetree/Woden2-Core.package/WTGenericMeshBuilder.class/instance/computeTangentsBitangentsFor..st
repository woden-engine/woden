as yet unclassified
computeTangentsBitangentsFor: submesh
	| triangleCount triangleTangents triangleBitangents indexBase i1 i2 i3 vi1 vi2 vi3 p1 p2 p3 u v tc1 tc2 tc3 det den tangent bitangent v1 v2 v3 du1 dv1 du2 dv2 |
	submesh primitiveType ~= AGPU_TRIANGLES ifTrue: [ ^ self ].
	triangleCount := submesh indexCount // 3.

	indexBase := submesh firstIndex.	
	i1 := indexBase + 1.
	i2 := indexBase + 2.
	i3 := indexBase + 3.
	1 to: triangleCount do: [ :ti |
		vi1 := (indices at: i1) + 1.
		vi2 := (indices at: i2) + 1.
		vi3 := (indices at: i3) + 1.
		
		p1 := (vertices at: vi1) position.
		p2 := (vertices at: vi2) position.
		p3 := (vertices at: vi3) position.

		tc1 := (vertices at: vi1) texcoord.
		tc2 := (vertices at: vi2) texcoord.
		tc3 := (vertices at: vi3) texcoord.

		u := p2 - p1.
		v := p3 - p1.
		
		du1 := tc2 x - tc1 x.
		dv1 := tc2 y - tc1 y.
		
		du2 := tc3 x - tc1 x.
		dv2 := tc3 y - tc1 y.
		
		det := (du1*dv2) - (du2*dv1).
		(det closeTo: 0.0) ifFalse: [ 
			den := 1.0 / det.
			
			tangent := (u * (den*dv2))  - (v * (den*dv1)).
			bitangent := (v * (den*du1)) - (u * (den*du2)).
			
			v1 := vertices at: vi1.
			v2 := vertices at: vi2.
			v3 := vertices at: vi3.
			
			v1 tangent: v1 tangent + tangent.
			v2 tangent: v2 tangent + tangent.
			v3 tangent: v3 tangent + tangent.

			v1 bitangent: v1 bitangent + bitangent.
			v2 bitangent: v2 bitangent + bitangent.
			v3 bitangent: v3 bitangent + bitangent.
			
			"These three should be removed when using the lowcode compiler."
			vertices at: vi1 put: v1.
			vertices at: vi2 put: v2.
			vertices at: vi3 put: v3.
		].
				
		i1 := i1 + 3.
		i2 := i2 + 3.
		i3 := i3 + 3.
	].
