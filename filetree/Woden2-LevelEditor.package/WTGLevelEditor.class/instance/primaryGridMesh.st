accessing
primaryGridMesh
	primaryGridMesh ifNotNil: [ ^ primaryGridMesh ].
	primaryGridMesh := (WTGenericMeshBuilder for: engine)
		material: self gridMaterial;
		color: Color gray;
		addLineGridWithWidth: 200 height: 200 subdivisions: 21;
		mesh.
	^ primaryGridMesh