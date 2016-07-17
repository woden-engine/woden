initialization
createSelectionBoxMesh
	| selectionCubeMaterial |
	selectionCubeMaterial := engine resourceCache loadMaterial: 'materials/basic/stipple.json'.
	selectionBoxMesh := (WTGenericMeshBuilder for: engine)
		material: selectionCubeMaterial;
		color: Color lightYellow;
		addWireCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		mesh.
