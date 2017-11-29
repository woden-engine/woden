accessing
secondaryGridMesh
	secondaryGridMesh ifNotNil: [ ^ secondaryGridMesh ].
	secondaryGridMesh := (WTGenericMeshBuilder for: engine)
		material: self gridMaterial;
		color: Color darkGray;
		addLineGridWithWidth: 200 height: 200 subdivisions: 201;
		mesh.
	^ secondaryGridMesh