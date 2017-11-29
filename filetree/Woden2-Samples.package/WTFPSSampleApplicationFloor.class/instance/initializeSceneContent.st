rendering
initializeSceneContent
	| meshBuilder mesh cube light material |
	camera transform translateByZ: 3.0.
	
	material := engine resourceCache loadMaterial: 'materials/demos/tile.json'.

	meshBuilder := WTComplexGenericMeshBuilder for: engine.
	meshBuilder
		currentMaterial: material;
		addCubeWithWidth: 10.0 height: 0.5 depth: 10.0;
		planeTextureScale: (WMVector2F x: 2.0 y: 2.0) offset: (WMVector2F x: 0.0 y: 0.0);
		computeTangentsBitangents.
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
		
	