rendering
initializeSceneContent
	| meshBuilder mesh cube light material |
	camera transform translateByZ: 3.0.
	
	material := engine resourceCache loadMaterial: 'materials/basic/checkboard.json'.

	meshBuilder := WTGenericMeshBuilder for: engine.
	meshBuilder
		currentMaterial: material;
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0.
		"addUVSphereRadius: 1.0 segments: 32 slices: 32."
	mesh := meshBuilder mesh.
	
	cube := WTSSpatialObject new.
	cube renderable: mesh.
	scene add: cube.
	
	light := WTSLightSource new.
	light point.
	light state
			intensity: (WMVector4F x: 1.0 y: 1.0 z: 0.3 w: 1.0) * 0.8.
	light transform
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.
		
	