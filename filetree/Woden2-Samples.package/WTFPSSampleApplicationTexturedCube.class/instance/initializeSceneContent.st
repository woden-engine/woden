rendering
initializeSceneContent
	| meshBuilder mesh cube light material |
	camera transform translateByZ: 3.0.
	
	material := engine resourceCache loadMaterial: 'materials/basic/checkboard.json'.

	meshBuilder := WTGenericMeshBuilder for: engine.
	meshBuilder
		currentMaterial: material;
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0.
	mesh := meshBuilder mesh.
	
	cube := WTSSpatialObject new.
	cube renderable: mesh.
	scene add: cube.
	
	light := WTSLightSource new.
	light point.
	light state
		intensity: Color yellow asWMVector4F.
	light transform
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.
		
	