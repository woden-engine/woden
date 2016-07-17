initialization
createSelectionBoxMesh
	| selectionCubeMaterial |
	selectionCubeMaterial := editor engine resourceCache loadMaterial: 'materials/basic/stipple.json'.
	boxMesh := (WTGenericMeshBuilder for: editor engine)
		material: selectionCubeMaterial;
		color: Color white;
		addWireCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		mesh.
