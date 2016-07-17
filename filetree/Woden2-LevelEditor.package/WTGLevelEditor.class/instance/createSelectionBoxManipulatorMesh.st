initialization
createSelectionBoxManipulatorMesh
	| flatColorMaterial |
	flatColorMaterial := engine resourceCache loadMaterial: 'materials/basic/flat-xray.json'.
	selectionBoxManipulatorMesh := (WTGenericMeshBuilder for: engine)
		material: flatColorMaterial;
		color: (Color white alpha: 0.5);
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		mesh.