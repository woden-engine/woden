rendering
initializeSceneContent
	| meshBuilder cube sunLight floorMaterial waterSurface skyBox skyMaterial waterMaterial magnumMesh height eyePosition |
	
	cameraAngle := WMVector3F y: Float pi.
	camera transform translateToX: 0.0 y: 1.0 z: -4.0.
	height := 1.6.
	eyePosition := 1.45.
	playerBox := WMBox3DF min: (WMVector3F x: -0.20 y: 0.0 - eyePosition z: -0.20) max: (WMVector3F x: 0.20 y: height - eyePosition z: 0.20).
	
	floorMaterial := engine resourceCache loadMaterial: 'materials/demos/tile.json'.
	waterMaterial := engine resourceCache loadMaterial: 'materials/demos/water.json'.
	skyMaterial := engine resourceCache loadMaterial: 'materials/demos/skybox.json'.
	
	"Add the floor"
	meshBuilder := WTComplexGenericMeshBuilder for: engine.
	meshBuilder
		currentMaterial: floorMaterial;
		"Bottom"
		translateToX: 0.0 y: -2.05 z: 0.0;
		addCubeWithWidth: 5.0 height: 0.1 depth: 5.0;

		translateToX: -4.5 y: -1.0 z: 0.0;
		addCubeWithWidth: 4.0 height: 2.0 depth: 5.0;
		
		translateToX: 4.5 y: -1.0 z: 0.0;
		addCubeWithWidth: 4.0 height: 2.0 depth: 5.0;
		
		translateToX: 0.0 y: -1.0 z: 4.5;
		addCubeWithWidth: 13.0 height: 2.0 depth: 4.0;
		
		translateToX: 0.0 y: -1.0 z: -4.5;
		addCubeWithWidth: 13.0 height: 2.0 depth: 4.0;
						
		"Use a planar texture coordinates"
		planeTextureScale: (WMVector2F x: 2.0 y: 2.0) offset: (WMVector2F x: 0.0 y: 0.0);
		computeTangentsBitangents.
	cube := WTSSpatialObject new.
	cube renderable: meshBuilder mesh.
	scene add: cube.

	"Add a light"
	sunLight := WTSLightSource new.
	sunLight directional.
	sunLight state
			intensity: (WMVector4F x: 1.0 y: 1.0 z: 0.8) normalized * 0.8.
	sunLight transform
		rotateDegreesOnX: -45;
		translateToX: 0.0 y: 1.5 z: 2.5.
		
	scene add: sunLight.

	"Add a magnum .357"
	magnumMesh := engine resourceCache loadMesh: 'models/demos/magnum.fmdl'.	
	floorGun := WTSSpatialObject new.
	floorGun renderable: magnumMesh.
	floorGun transform translateToX: -0.5 y: magnumMesh boundingBox height * 0.5 z: -3.5.
	scene add: floorGun.
	
	"Add the sky box"
	meshBuilder := WTGenericMeshBuilder for: engine.
	meshBuilder
		currentMaterial: skyMaterial;
		addInteriorCubeWithWidth: 40.0 height: 40.0 depth: 40.0.

	skyBox := WTSSpatialObject new.
	skyBox renderable: meshBuilder mesh.
	scene add: skyBox.

	"Setup the water material"
	waterMaterial
		skyTexture: skyMaterial skyTexture;
		harmonicAt: 1 amplitude: 0.05 frequency: 1.1 center: WMVector2F new;
		harmonicAt: 2 amplitude: 0.02 frequency: 2.23 direction: (WMVector2F y: 1.0);
		harmonicAt: 3 amplitude: 0.015 frequency: 1.80 direction: (WMVector2F x: 1.0).

	"Add the water"
	meshBuilder := WTGenericMeshBuilder for: engine.
	meshBuilder
		currentMaterial: waterMaterial;
		addGridWithWidth: 5.0 height: 5.0 subdivisions: 64.
		
	waterSurface := WTSSpatialObject new.
	waterSurface translucentRenderPriority.
	waterSurface renderable: meshBuilder mesh.
	waterSurface transform translateToX: 0.0 y: -0.3 z: 0.0.
	scene add: waterSurface.