Class {
	#name : #WDASceneExamples,
	#superclass : #Object,
	#category : 'WodenEngine-Scene-Examples'
}

{ #category : #examples }
WDASceneExamples class >> example01Cube [
	| model meshBuilder mesh cube light scene camera |
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera transform translateByZ: 3.0.
	
	meshBuilder := WDCGenericMeshBuilder for: scene engine.
	meshBuilder addCubeWithWidth: 1.0 height: 1.0 depth: 1.0.
	mesh := meshBuilder mesh.
	
	cube := WDSGSpatialObject new.
	cube renderable: mesh.
	scene add: cube.
	
	light := WDSGLightSource new.
	light point.
	light state
		intensity: Color yellow asWMVector4F.
	light transform
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.

	model openWith: WDAFPSSceneView.
]

{ #category : #examples }
WDASceneExamples class >> example02TextureCube [
	| model meshBuilder mesh cube light scene camera material |
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera transform translateByZ: 3.0.
	
	material := scene engine resourceCache loadMaterial: 'materials/basic/checkboard.json'.
	
	meshBuilder := WDCGenericMeshBuilder for: scene engine.
	meshBuilder
		currentMaterial: material;
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0.
	mesh := meshBuilder mesh.
	
	cube := WDSGSpatialObject new.
	cube renderable: mesh.
	scene add: cube.
	
	light := WDSGLightSource new.
	light point.
	light state
		intensity: Color yellow asWMVector4F.
	light transform
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.

	model openWith: WDAFPSSceneView.
]

{ #category : #examples }
WDASceneExamples class >> example03Floor [
	| model meshBuilder mesh cube light scene camera material |
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera transform translateByX: 0.0 y: 1.0 z: 3.0.
	
	material := scene engine resourceCache loadMaterial: 'materials/demos/tile.json'.

	meshBuilder := WDCComplexGenericMeshBuilder for: scene engine.
	meshBuilder
		currentMaterial: material;
		addCubeWithWidth: 10.0 height: 0.5 depth: 10.0;
		planeTextureScale: (WMVector2F x: 2.0 y: 2.0) offset: (WMVector2F x: 0.0 y: 0.0);
		computeTangentsBitangents.
	mesh := meshBuilder mesh.
	
	cube := WDSGSpatialObject new.
	cube renderable: mesh.
	scene add: cube.
	
	light := WDSGLightSource new.
	light point.
	light state
			intensity: (WMVector4F x: 1.0 y: 1.0 z: 0.3 w: 1.0) * 0.8.
	light transform
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.

	model openWith: WDAFPSSceneView.
]

{ #category : #examples }
WDASceneExamples class >> example04Pool [
	| model meshBuilder cube scene camera engine floorMaterial waterMaterial skyMaterial sunLight skyBox waterSurface view floor mesh |
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera farDistance: 100.0.
	camera transform translateToX: 0.0 y: 1.0 z: -4.0.
	engine := scene engine.
	
	floorMaterial := engine resourceCache loadMaterial: 'materials/demos/tile.json'.
	waterMaterial := engine resourceCache loadMaterial: 'materials/demos/water.json'.
	skyMaterial := engine resourceCache loadMaterial: 'materials/demos/skybox.json'.
	
	"Add the floor"
	meshBuilder := WDCComplexGenericMeshBuilder for: engine.
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
	floor := WDSGSpatialObject new.
	floor renderable: meshBuilder mesh.
	scene add: floor.
	
	"Add a cube"
	meshBuilder := WDCGenericMeshBuilder for: scene engine.
	meshBuilder addCubeWithWidth: 1.0 height: 1.0 depth: 1.0.
	mesh := meshBuilder mesh.
	
	cube := WDSGSpatialObject new.
	cube renderable: mesh.
	cube transform translateByX: 4.5 y: 0.5 z: 0.0.
	scene add: cube.


	"Add a light"
	sunLight := WDSGLightSource new.
	sunLight directional; castShadows: true.
	sunLight state
			intensity: (WMVector4F x: 1.0 y: 1.0 z: 0.8) normalized * 0.8.
	sunLight transform
		rotateDegreesOnX: -45;
		translateToX: 0.0 y: 1.5 z: 2.5.
		
	scene add: sunLight.
		
	"Add the sky box"
	meshBuilder := WDCGenericMeshBuilder for: engine.
	meshBuilder
		currentMaterial: skyMaterial;
		addInteriorCubeWithWidth: 40.0 height: 40.0 depth: 40.0.

	skyBox := WDSGSpatialObject new.
	skyBox isOpaqueShadowCaster: false;
		renderable: meshBuilder mesh.
	scene add: skyBox.

	"Setup the water material"
	waterMaterial
		skyTexture: skyMaterial skyTexture;
		harmonicAt: 1 amplitude: 0.05 frequency: 1.1 center: WMVector2F new;
		harmonicAt: 2 amplitude: 0.02 frequency: 2.23 direction: (WMVector2F y: 1.0);
		harmonicAt: 3 amplitude: 0.015 frequency: 1.80 direction: (WMVector2F x: 1.0).

	"Add the water"
	meshBuilder := WDCGenericMeshBuilder for: engine.
	meshBuilder
		currentMaterial: waterMaterial;
		addGridWithWidth: 5.0 height: 5.0 subdivisions: 64.
		
	waterSurface := WDSGSpatialObject new.
	waterSurface translucentRenderPriority;
		isOpaqueShadowCaster: false;
		renderable: meshBuilder mesh.
	waterSurface transform translateToX: 0.0 y: -0.3 z: 0.0.
	scene add: waterSurface.
	
	view := WDAFPSSceneView new.
	view cameraAngle: (WMVector3F y: Float pi).
	model openWith: view.
]

{ #category : #examples }
WDASceneExamples class >> example05DangerousPool [
	| model meshBuilder cube scene camera engine floorMaterial waterMaterial skyMaterial sunLight skyBox waterSurface view magnumMesh pickedGun animationState gunAction gunActionFrame gunActionRepeated |
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera farDistance: 100.0.
	camera transform translateToX: 0.0 y: 1.0 z: -4.0.
	engine := scene engine.
	
	floorMaterial := engine resourceCache loadMaterial: 'materials/demos/tile.json'.
	waterMaterial := engine resourceCache loadMaterial: 'materials/demos/water.json'.
	skyMaterial := engine resourceCache loadMaterial: 'materials/demos/skybox.json'.
	
	"Add the floor"
	meshBuilder := WDCComplexGenericMeshBuilder for: engine.
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
	cube := WDSGSpatialObject new.
	cube renderable: meshBuilder mesh.
	scene add: cube.

	"Add a light"
	sunLight := WDSGLightSource new.
	sunLight directional; castShadows: true.
	sunLight state
			intensity: (WMVector4F x: 1.0 y: 1.0 z: 0.8) normalized * 0.8.
	sunLight transform
		rotateDegreesOnX: -45;
		translateToX: 0.0 y: 1.5 z: 2.5.
		
	scene add: sunLight.
		
	"Add the sky box"
	meshBuilder := WDCGenericMeshBuilder for: engine.
	meshBuilder
		currentMaterial: skyMaterial;
		addInteriorCubeWithWidth: 40.0 height: 40.0 depth: 40.0.

	skyBox := WDSGSpatialObject new.
	skyBox isOpaqueShadowCaster: false;
		renderable: meshBuilder mesh.
	scene add: skyBox.

	"Setup the water material"
	waterMaterial
		skyTexture: skyMaterial skyTexture;
		harmonicAt: 1 amplitude: 0.05 frequency: 1.1 center: WMVector2F new;
		harmonicAt: 2 amplitude: 0.02 frequency: 2.23 direction: (WMVector2F y: 1.0);
		harmonicAt: 3 amplitude: 0.015 frequency: 1.80 direction: (WMVector2F x: 1.0).

	"Add the water"
	meshBuilder := WDCGenericMeshBuilder for: engine.
	meshBuilder
		currentMaterial: waterMaterial;
		addGridWithWidth: 5.0 height: 5.0 subdivisions: 64.
		
	waterSurface := WDSGSpatialObject new.
	waterSurface translucentRenderPriority;
		isOpaqueShadowCaster: false;
		renderable: meshBuilder mesh.
	waterSurface transform translateToX: 0.0 y: -0.3 z: 0.0.
	scene add: waterSurface.
	
	magnumMesh := (engine resourceCache load3DModel: 'models/demos/magnum_fps.wmjson')
		combineSubmeshesWithMaterial: 'materials/demos/magnum_fps.json';
		meshFor: engine.
		
	pickedGun := WDSGSpatialObject new.
	pickedGun renderable: magnumMesh.
	camera addChild: pickedGun.

	animationState := pickedGun renderableSceneData.
	gunAction := animationState actionNamed: 'Draw'.
	gunActionFrame := 0.0.
	gunActionRepeated := false.
	
	model onDeltaTimeDo: [ :delta |
		gunActionFrame := gunActionFrame + (delta *30.0).
		pickedGun renderableSceneData
			setRestPose;
			addAction: gunAction repeated: gunActionRepeated frame: gunActionFrame;
			computePoseMatrices.
		(gunActionRepeated not and: [ gunActionFrame > 35 ]) ifTrue: [
			gunAction := pickedGun renderable actions at: 'Idle'.
			gunActionFrame := 0.
			gunActionRepeated := true.
		]
	].
	
	view := WDAFPSSceneView new.
	view cameraAngle: (WMVector3F y: Float pi).
	model openWith: view.
]

{ #category : #examples }
WDASceneExamples class >> example06MeshGrid [
	| model meshBuilder mesh cube light scene camera material |
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera transform translateByZ: 3.0.
	
	material := scene engine resourceCache loadMaterial: 'materials/basic/flat.json'.
	
	meshBuilder := WDCGenericMeshBuilder for: scene engine.
	meshBuilder
		currentMaterial: material;
		addLineGridWithWidth: 2.0 height: 2.0 subdivisions: 32.
	mesh := meshBuilder mesh.
	
	cube := WDSGSpatialObject new.
	cube renderable: mesh.
	scene add: cube.
	
	light := WDSGLightSource new.
	light point.
	light state
		intensity: Color yellow asWMVector4F.
	light transform
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.

	model openWith: WDAFPSSceneView.
]

{ #category : #examples }
WDASceneExamples class >> example07SmallTerrain [
	| model material mesh terrain light scene camera |
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera transform translateByZ: 3.0; translateByY: 1.0.

	material := WDCTerrainMaterial for: scene engine.
	material heightMapTexture: (scene engine resourceCache grayTextureExtent: 128@128 renderWith: [ :s :t |
		| x y |
		x := s *2.0 - 1.0.
		y := t *2.0 - 1.0.
		1.0 - (x abs max: y abs)
	]).
	
	mesh := (WDCGenericMeshBuilder for: scene engine)
		currentMaterial: material;
		addGridWithWidth: 5.0 height: 5.0 subdivisions: 64;
		mesh.
		
	terrain := WDSGSpatialObject new.
	terrain transform translateByY: -1.0.
	terrain renderable: mesh.
	scene add: terrain.
	
	light := WDSGLightSource new.
	light point.
	light state
		intensity: Color yellow asWMVector4F.
	light transform
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.

	model openWith: WDAFPSSceneView.
]

{ #category : #'example models' }
WDASceneExamples class >> exampleModelBunny [
	(WDCEngine default resourceCache load3DModel: 'models/stanford/bun_zipper.ply') openViewer
]

{ #category : #'example models' }
WDASceneExamples class >> exampleModelCube [
	(WDCEngine default resourceCache load3DModel: 'models/obj/cube.obj') openViewer
]

{ #category : #'see class side' }
WDASceneExamples >> seeClassSide [
]
