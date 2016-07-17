initialization
createSelectionBoxManipulatorMesh
	| flatColorMaterial |
	flatColorMaterial := editor engine resourceCache loadMaterial: 'materials/basic/flat-xray.json'.
	manipulatorMesh := (WTGenericMeshBuilder for: editor engine)
		material: flatColorMaterial;
		color: (Color white alpha: 1.0);
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		mesh.