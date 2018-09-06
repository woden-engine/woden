Class {
	#name : #WDASceneExamples,
	#superclass : #Object,
	#category : 'WodenEngine-Scene-Examples'
}

{ #category : #'examples procedural' }
WDASceneExamples class >> cloudTexture [
	"
	self cloudTexture inspect
	"
	| textureSize skyColor colorRamp |
	textureSize := 5.0.
	skyColor := Color fromHexString: '68e3ee'.
	colorRamp := WDCLinearRamp with: { 
		0.4 -> skyColor.
		1.0 -> Color white.
	}.

	^ WDCTextureData extent: 128@128 srgbColorRenderWith: [ :s :t |
		|st cloud |
		st := (s@t)*textureSize.
		cloud := (st fractionalBrownianMotionOctaves: 4 lacunarity: 2.0 initialAmplitude: 0.9 with: #signedGradientNoise)*0.5 +0.5.
	
		colorRamp value: cloud.
	]
]

{ #category : #'examples procedural' }
WDASceneExamples class >> createIslandTerrainObjectFor: engine [
	| material mesh terrain terrainMaps |
	terrainMaps := self islandTerrainMaps: 128.
		
	material := WDCTerrainMaterial for: engine.
	material
		heightMapScale: (WMVector2F x: 1.0 y: 1.0)/100.0;
		heightScale: 110.0;
		heightMapTexture: (terrainMaps first asTextureFor: engine);
		splattingTexture: (terrainMaps second asTextureFor: engine);
		albedoTextures: {
			(self sandTexture) asSRGBTextureFor: engine.
			(self grassTexture) asSRGBTextureFor: engine.
			(self rockTexture) asSRGBTextureFor: engine.
			(self snowTexture) asSRGBTextureFor: engine.
			nil
		}.
	
	mesh := (WDCTerrainMeshBuilder for: engine)
		material: material;
		createClipMapWithLevels: 3 size: (WMVector2F x: 40.0 y: 40.0) subdivisions: 128;
		mesh.
		
	terrain := WDSGSpatialObject new.
	terrain renderable: mesh.
	
	^ terrain
]

{ #category : #'examples procedural' }
WDASceneExamples class >> createIslandWaterObjectFor: engine skyTexture: skyTexture [
	"Setup the water material"
	| material mesh waterObject |
	material := (engine resourceCache loadMaterial: 'materials/demos/water.json') copy.
	material
		skyTexture: skyTexture;
		harmonicAt: 1 amplitude: 0.02 frequency: 2.23 direction: (WMVector2F y: 1.0);
		harmonicAt: 2 amplitude: 0.015 frequency: 1.80 direction: (WMVector2F x: 1.0).

	"Add the water"
	mesh := (WDCTerrainMeshBuilder for: engine)
		material: material;
		createClipMapWithLevels: 3 size: (WMVector2F x: 40.0 y: 40.0) subdivisions: 128;
		mesh.
		
	waterObject := WDSGSpatialObject new.
	waterObject translucentRenderPriority;
		isOpaqueShadowCaster: false;
		renderable: mesh.
	^ waterObject
]

{ #category : #'examples procedural' }
WDASceneExamples class >> createSkybox: extent for: engine material: skyMaterial [
	| meshBuilder skyBox |
	meshBuilder := WDCGenericMeshBuilder for: engine.
	meshBuilder
		currentMaterial: skyMaterial;
		addInteriorCubeWithWidth: extent x height: extent y depth: extent z.

	skyBox := WDSGSpatialObject new.
	skyBox isOpaqueShadowCaster: false;
		renderable: meshBuilder mesh.
	^ skyBox
]

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
	| model meshBuilder cube scene camera engine floorMaterial waterMaterial skyMaterial sunLight skyBox waterSurface view floor mesh waterMesh |
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
	waterMesh := (WDCTerrainMeshBuilder for: scene engine)
		material: waterMaterial;
		createGridWithSize: (WMVector2F x: 5.0 y: 5.0) subdivisions: 64;
		mesh.
		
	waterSurface := WDSGSpatialObject new.
	waterSurface translucentRenderPriority;
		isOpaqueShadowCaster: false;
		renderable: waterMesh.
	waterSurface transform translateToX: 0.0 y: -0.3 z: 0.0.
	scene add: waterSurface.
	
	view := WDAFPSSceneView new.
	view cameraAngle: (WMVector3F y: Float pi).
	model openWith: view.
]

{ #category : #examples }
WDASceneExamples class >> example05DangerousPool [
	| model meshBuilder cube scene camera engine floorMaterial waterMaterial skyMaterial sunLight skyBox waterSurface view magnumMesh pickedGun animationState gunAction gunActionFrame gunActionRepeated waterMesh |
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
	waterMesh := (WDCTerrainMeshBuilder for: scene engine)
		material: waterMaterial;
		createGridWithSize: (WMVector2F x: 5.0 y: 5.0) subdivisions: 64;
		mesh.
		
	waterSurface := WDSGSpatialObject new.
	waterSurface translucentRenderPriority;
		isOpaqueShadowCaster: false;
		renderable: waterMesh.
	waterSurface transform translateToX: 0.0 y: -0.3 z: 0.0.
	scene add: waterSurface.
	
	magnumMesh := engine resourceCache loadMesh: 'models/demos/magnum_fps.fmdl'.
	
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
	| model material mesh terrain light scene camera heightMap |
	
	"Some procedural textures used by the demo"
	heightMap := WDCTextureData extent: 128@128 signedHeightRenderWith: [ :s :t |
		|st|
		st := s@t.
		st*3.0 fractionalBrownianMotionOctaves: 5 lacunarity: 1.45 initialAmplitude: 0.5 with: [ :c : a|
			(c signedGradientNoise *a) abs
		]
	].
	
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera farDistance: 100.0.
	camera transform translateByZ: 3.0; translateByY: 1.0.

	material := WDCTerrainMaterial for: scene engine.
	material
		heightMapScale: (WMVector2F x: 1.0 y: 1.0)/10.0;
		heightScale: 8.0;
		heightMapTexture: (heightMap asTextureFor: scene engine).
	
	mesh := (WDCTerrainMeshBuilder for: scene engine)
		material: material;
		createGridWithSize: (WMVector2F x: 20.0 y: 20.0) subdivisions: 128;
		mesh.
		
	terrain := WDSGSpatialObject new.
	terrain transform translateByY: -1.0.
	terrain renderable: mesh.
	scene add: terrain.
	
	light := WDSGLightSource new.
	light directional; castShadows: true.
	light state
		intensity: (Color fromHexString: 'f1efd7') asWMVector4F.
	light transform
		rotateDegreesOnX: -45;
		rotateDegreesOnY: 135;
		translateToX: 0.0 y: 1.5 z: 2.5.
	scene add: light.

	model openWith: WDAFPSSceneView.
]

{ #category : #examples }
WDASceneExamples class >> example08MediumTerrain [
	| model material mesh terrain light scene camera heightMap |
	
	"Some procedural textures used by the demo"
	heightMap := [WDCTextureData extent: 256@256 signedHeightRenderWith: [ :s :t |
		|st|
		st := s@t.
		st*10.0 fractionalBrownianMotionOctaves: 8 lacunarity: 1.45 initialAmplitude: 0.5 with: [ :c : a|
			(c signedGradientNoise *a) abs
		]
	]] valueCachedInDisk.
	
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera farDistance: 200.0.
	camera transform translateByZ: 3.0; translateByY: 1.0.

	material := WDCTerrainMaterial for: scene engine.
	material
		heightMapScale: (WMVector2F x: 1.0 y: 1.0)/100.0;
		heightScale: 8.0;
		heightMapTexture: (heightMap asTextureFor: scene engine).
	
	mesh := (WDCTerrainMeshBuilder for: scene engine)
		material: material;
		createClipMapWithLevels: 3 size: (WMVector2F x: 20.0 y: 20.0) subdivisions: 128;
		mesh.
		
	terrain := WDSGSpatialObject new.
	terrain transform translateByY: -1.0.
	terrain renderable: mesh.
	scene add: terrain.
	
	light := WDSGLightSource new.
	light directional; castShadows: true.
	light state
		intensity: (Color fromHexString: 'f1efd7') asWMVector4F.
	light transform
		rotateDegreesOnX: -45;
		rotateDegreesOnY: 135;
		translateToX: 0.0 y: 1.5 z: 2.5.
	scene add: light.

	model openWith: WDAFPSSceneView.
]

{ #category : #examples }
WDASceneExamples class >> example09Island [
	| model terrain light scene camera water view skyMaterial skyBox |
	
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera farDistance: 250.0.
	camera transform translateByZ: 70.0; translateByY: 1.0.
	
	skyMaterial := scene engine resourceCache loadMaterial: 'materials/demos/skybox.json'.
	skyBox := self createSkybox: (WMVector3F x: 200.0 y: 200.0 z: 200.0) for: scene engine material: skyMaterial.
	scene add: skyBox.

	terrain := self createIslandTerrainObjectFor: scene engine.
	scene add: terrain.

	water := self createIslandWaterObjectFor: scene engine skyTexture: skyMaterial skyTexture.
	scene add: water.
	
	light := WDSGLightSource new.
	light directional; castShadows: false.
	light state
		intensity: (Color fromHexString: 'f1efd7') asWMVector4F.
	light transform
		rotateDegreesOnX: -45;
		translateToX: 0.0 y: 1.5 z: 2.5.
	scene add: light.

	view := model openWith: WDAFPSSceneView
]

{ #category : #'example models' }
WDASceneExamples class >> exampleModelBunny [
	(WDCEngine default resourceCache load3DModel: 'models/stanford/bun_zipper.ply') openViewer
]

{ #category : #'example models' }
WDASceneExamples class >> exampleModelCube [
	(WDCEngine default resourceCache load3DModel: 'models/obj/cube.obj') openViewer
]

{ #category : #'examples procedural' }
WDASceneExamples class >> grassTexture [
	| textureSize colorRamp |
	textureSize := 40.0@40.0.
	colorRamp := WDCLinearRamp with: { 
		0.3 -> Color green muchDarker.
		1.0 -> Color green.
	}.
	
	^ [ WDCTextureData extent: 256@256 srgbColorRenderWith: [ :s :t |
		| st grassFunction |
		st := s@t.
		grassFunction := st*textureSize fractionalBrownianMotionOctaves: 4 lacunarity: 2.0 initialAmplitude: 0.5 tiledWith: textureSize with: #gradientNoiseTiledWith:.
		colorRamp value: grassFunction
	] ] valueCachedInDisk
]

{ #category : #'examples procedural' }
WDASceneExamples class >> islandTerrainMaps: textureExtent [
	| islandOuterRadius islandInnerRadius maximumHeight seabedLevel heightScale islandBaseLevel snowStartHeight |
	islandOuterRadius := 100.0.
	islandInnerRadius := islandOuterRadius - 50.0.
	maximumHeight := 100.0.
	seabedLevel := -10.0.
	islandBaseLevel := 1.0.
	heightScale := 110.0.

	snowStartHeight := 45.0.
	
	^ [WDCTextureData extent: textureExtent@textureExtent terrainMapsRenderWith: [ :s :t |
		| st p r theta innerRadius
		 boundaries heightAttenuation
		 islandInterior mountainHeight
		 sand rock grass snow notInSnow
		 heightValue|
		"Compute the coordinates"
		st := s@t.
		p := (st*2.0 - 1.0) * islandOuterRadius.

		r := p distanceTo: 0@0.
		theta := p theta.
	
		"Generate the island boundaries"
		innerRadius := islandOuterRadius - 50.0 - (((theta*1.5 + 12.0) turbulence)*35.0) min: islandOuterRadius.
		sand := r smoothStepFrom: innerRadius to: islandOuterRadius.
		boundaries := (r smoothStepFrom: innerRadius to: islandOuterRadius ) fuzzyNot.
		heightAttenuation := (r smoothStepFrom: 0.0 to: innerRadius) fuzzyNot.

		"Generate the mountains"
		mountainHeight := (st*5.0 fractionalBrownianMotionOctaves: 5 lacunarity: 2.1245 initialAmplitude: 1.0 with: [:c | c signedGradientNoise])*0.5 + 0.5 * (maximumHeight * heightAttenuation).

		snow := mountainHeight smoothStepFrom: snowStartHeight to: snowStartHeight + 2.0.
		notInSnow := snow fuzzyNot.
		grass := ((st*13.0) turbulence - ((mountainHeight max: 0.0)/maximumHeight*10.0) + 0.1 max: 0.0) productFuzzyAnd: sand fuzzyNot.
		rock := snow fuzzyNot productFuzzyAnd: sand fuzzyNot.
	
		"Generate the stuff in the island interior"
		islandInterior := islandBaseLevel + mountainHeight.

		heightValue := seabedLevel interpolateTo: islandInterior at: boundaries.
		{heightValue / heightScale . {sand . grass . rock . snow . 0.0}}.
] ] valueCachedInDisk
]

{ #category : #'examples procedural' }
WDASceneExamples class >> rockTexture [
	| textureSize colorRamp |
	textureSize := 7.0@7.0.
	colorRamp := WDCLinearRamp with: { 
		0.0 -> '8a6025' asColor.
		1.0 -> 'f7d8ac' asColor.
	}.
	
	^ [WDCTextureData extent: 256@256 srgbColorRenderWith: [ :s :t |
		| cracks st bumps height |
		st := s@t.

		cracks := (st*textureSize fractionalBrownianMotionOctaves: 3 lacunarity: 2.0 initialAmplitude: 0.6 tiledWith: textureSize with: #worleyNoiseTiledWith:)*3.0 min: 1.0.
		bumps := st*textureSize*4.0 fractionalBrownianMotionOctaves: 4 lacunarity: 2.0 initialAmplitude: 1.0 tiledWith: textureSize*4.0 with: #signedGradientNoiseTiledWith:.
		height := (cracks*0.5) + (bumps*0.3).
		
		colorRamp value: height
	]] valueCachedInDisk
]

{ #category : #'examples procedural' }
WDASceneExamples class >> sandTexture [
	| textureSize colorRamp st sandFunction |
	textureSize := 30.0@30.0.
	colorRamp := WDCLinearRamp with: { 
		0.0 -> Color black.
		1.0 -> (Color fromHexString: 'b7a18b').
	}.
	
	^ [ WDCTextureData extent: 128@128 srgbColorRenderWith: [ :s :t |
		st := s@t.
		sandFunction := st*textureSize fractionalBrownianMotionOctaves: 4 lacunarity: 2.0 initialAmplitude: 0.6 tiledWith: textureSize with: #gradientNoiseTiledWith:.
		colorRamp value: sandFunction
	] ] valueCachedInDisk.
]

{ #category : #'examples procedural' }
WDASceneExamples class >> snowTexture [
	| textureSize colorRamp |
	textureSize := 20.0@20.0.
	colorRamp := WDCLinearRamp with: { 
		0.05 -> '25525c' asColor.
		0.4 -> Color white.
	}.
	
	^ [WDCTextureData extent: 256@256 srgbColorRenderWith: [ :s :t |
		| st snowFunction |
		st := s@t.
		snowFunction := st*textureSize fractionalBrownianMotionOctaves: 4 lacunarity: 2.0 initialAmplitude: 0.4 tiledWith: textureSize with: #gradientNoiseTiledWith:.
		colorRamp value: snowFunction
	] ] valueCachedInDisk
]

{ #category : #'see class side' }
WDASceneExamples >> seeClassSide [
]
