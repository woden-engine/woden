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

{ #category : #examples }
WDASceneExamples class >> constructPoolMeshWith: meshBuilder [
	| engine tilesMaterial concreteMaterial borderThickness |
	engine := meshBuilder engine.
	tilesMaterial := engine resourceCache loadMaterial: 'materials/demos/tile.json'.
	concreteMaterial := engine resourceCache loadMaterial: 'materials/demos/esug-floor.json'.
	
	"Add the floor"
	borderThickness := 0.5.
	meshBuilder
		currentMaterial: tilesMaterial;

		translateToX: (borderThickness*0.5) negated - 4.5 y: -1.0 z: 0.0;
		addCubeWithWidth: 4.0 - borderThickness height: 2.0 depth: 5.0 + (borderThickness*2.0);
		addCollisionBox;
		
		translateToX: (borderThickness*0.5)+ 4.5 y: -1.0 z: 0.0;
		addCubeWithWidth: 4.0 - borderThickness height: 2.0 depth: 5.0 + (borderThickness*2.0);
		addCollisionBox;
		
		translateToX: 0.0 y: -1.0 z: borderThickness + 4.5;
		addCubeWithWidth: 13.0 height: 2.0 depth: 4.0;
		addCollisionBox;
		
		translateToX: 0.0 y: -1.0 z: borderThickness negated - 4.5;
		addCubeWithWidth: 13.0 height: 2.0 depth: 4.0;
		addCollisionBox;

		"Bottom"
		currentMaterial: concreteMaterial;
		translateToX: 0.0 y: -2.05 z: 0.0;
		addCubeWithWidth: 5.0 height: 0.1 depth: 5.0;
		addCollisionBox;

		"Border"
		translateToX: -2.5 - (borderThickness*0.5) y: -1.0 z: 0.0;
		addCubeWithWidth: borderThickness height: 2.2 depth: 5.0 + (borderThickness*2.0);
		addCollisionBox;
		
		translateToX: 2.5 + (borderThickness*0.5) y: -1.0 z: 0.0;
		addCubeWithWidth: borderThickness height: 2.2 depth: 5.0 + (borderThickness*2.0);
		addCollisionBox;
		
		translateToX: 0.0 y: -1.0 z: 2.5 + (borderThickness*0.5);
		addCubeWithWidth: 5.0 height: 2.2 depth: borderThickness;
		addCollisionBox;
		
		translateToX: 0.0 y: -1.0 z: -2.5 - (borderThickness*0.5);
		addCubeWithWidth: 5.0 height: 2.2 depth: borderThickness;
		addCollisionBox;

		"Use a planar texture coordinates"
		planeTextureScale: (WMVector2F x: 2.0 y: 2.0) offset: (WMVector2F x: 0.0 y: 0.0);
		computeTangentsBitangents.

]

{ #category : #examples }
WDASceneExamples class >> constructPoolSceneInto: scene [
	| engine waterMaterial meshBuilder floor mesh cube waterMesh waterSurface |
	engine := scene engine.
	waterMaterial := engine resourceCache loadMaterial: 'materials/demos/water.json'.
	
	"Add the floor"
	meshBuilder := WDCComplexGenericMeshBuilder for: engine.
	self constructPoolMeshWith: meshBuilder.
	floor := WDSGSpatialObject new.
	floor renderable: meshBuilder mesh.
	scene add: floor.
	
	"Add a cube"
	meshBuilder := WDCGenericMeshBuilder for: scene engine.
	meshBuilder addCubeWithWidth: 1.0 height: 1.0 depth: 1.0.
	mesh := meshBuilder mesh.
	
	cube := WDSGSpatialObject new.
	cube
		renderable: mesh;
		translateByX: 4.5 y: 0.5 z: 0.0.
	scene add: cube.

	"Add the water"
	waterMesh := (WDCTerrainMeshBuilder for: scene engine)
		material: waterMaterial;
		heightScale: 0.1;
		createGridWithSize: (WMVector2F x: 5.0 y: 5.0) subdivisions: 64;
		waterMesh.
	waterMesh deformationState
		harmonicAt: 1 amplitude: 0.05 frequency: -1.1 center: WMVector2F new;
		harmonicAt: 2 amplitude: 0.02 frequency: 2.23 direction: (WMVector2F y: -1.0);
		harmonicAt: 3 amplitude: 0.015 frequency: 1.80 direction: (WMVector2F x: 1.0).
		
	waterSurface := WDSGSpatialObject new.
	waterSurface
		renderable: waterMesh;
		translateToX: 0.0 y: -0.3 z: 0.0.
	scene add: waterSurface.
]

{ #category : #'examples procedural' }
WDASceneExamples class >> createIslandTerrainObjectFor: engine [
	| material mesh terrain |
	material := engine resourceCache loadMaterial: 'materials/demos/island.json'.
	
	terrain := WDSGSpatialObject new.
	mesh := material createTerrainMeshForSceneNode: terrain.		
	terrain renderable: mesh.
	
	^ terrain
]

{ #category : #'examples procedural' }
WDASceneExamples class >> createIslandWaterObjectFor: engine [
	"Setup the water material"
	| material mesh waterObject |
	material := (engine resourceCache loadMaterial: 'materials/demos/ocean.json').

	"Add the water"
	mesh := (WDCTerrainMeshBuilder for: engine)
		material: material;
		heightScale: 0.1;
		createClipMapWithLevels: 3 size: (WMVector2F x: 40.0 y: 40.0) subdivisions: 128;
		waterMesh.

	mesh deformationState
		harmonicAt: 1 amplitude: 0.015 frequency: 2.23 center: (WMVector2F zero);
		harmonicAt: 2 amplitude: 0.03 frequency: 0.50 center: (WMVector2F zero).

	waterObject := WDSGSpatialObject new.
	waterObject renderable: mesh.
	^ waterObject
]

{ #category : #examples }
WDASceneExamples class >> example01Cube [
	| model meshBuilder mesh cube light scene camera |
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera translateByZ: 3.0.
	
	meshBuilder := WDCGenericMeshBuilder for: scene engine.
	meshBuilder addCubeWithWidth: 1.0 height: 1.0 depth: 1.0.
	mesh := meshBuilder mesh.
	
	cube := WDSGSpatialObject new.
	cube renderable: mesh.
	scene add: cube.
	
	light := WDSGLightSource new.
	light point.
	light
		radius: 4.0; 
		intensity: Color yellow asWMVector4F * 5.0;
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.

	model openWith: WDAFPSSceneView allowingVR.
]

{ #category : #examples }
WDASceneExamples class >> example02TextureCube [
	| model meshBuilder mesh cube light scene camera material |
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera translateByZ: 3.0.
	
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
	light
		point;
		intensity: Color yellow asWMVector4F;
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
	camera translateByX: 0.0 y: 1.0 z: 3.0.
	
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
	light
		point;
		intensity: (WMVector4F x: 1.0 y: 1.0 z: 0.3 w: 1.0) * 0.8;
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.

	model openWith: WDAFPSSceneView.
]

{ #category : #examples }
WDASceneExamples class >> example04Pool [
	| model scene camera engine sunLight view skyTexture |
	model := WDASampleSceneModel new.
	scene := model newScene.
	engine := model engine.
	camera := model camera.
	camera
		farDistance: 100.0.
	camera translateToX: 0.0 y: 1.0 z: -4.0.
	
	self constructPoolSceneInto: scene.


	"Add a light"
	sunLight := WDSGLightSource new.
	sunLight
		directional;
		castShadows: true;
		intensity: (WMVector4F x: 1.0 y: 1.0 z: 0.8) normalized * 0.7;
		rotateDegreesOnX: -35;
		translateToX: 0.0 y: 1.5 z: 2.5.

	scene add: sunLight.

	scene ambientLighting: WMVector4F ones.

	"Create the sky."
	skyTexture := self proceduralSkySunDirection: (sunLight transform transformVector3: (WMVector3F z: 1.0)).
	skyTexture := skyTexture asSRGBTextureFor: engine.
	scene createSkyWithCubeTexture: skyTexture.

	view := WDAFPSSceneView allowingVR.
	model openWith: view.
]

{ #category : #examples }
WDASceneExamples class >> example04ProceduralSky [
	| texture model scene material camera meshBuilder mesh cube sunDirection |
	model := WDASampleSceneModel new.
	scene := model newScene.
	material := WDCSkyMaterial for: model engine.

	camera := model camera.
	camera translateByY: 1.7.
	
	meshBuilder := WDCGenericMeshBuilder for: scene engine.
	meshBuilder
		defaultMaterial;
		addCubeWithWidth: 10.0 height: 0.5 depth: 10.0;
		material: material;
		addInteriorCubeWithWidth: 10.0 height: 10.0 depth: 10.0.
	mesh := meshBuilder mesh.
	
	cube := WDSGSpatialObject new.
	cube renderable: mesh.
	scene add: cube.
	
	sunDirection := WMReversibleAffineTransformF identity
		rotateDegreesOnX: -45;
		transformVector3: (WMVector3F z: 1.0).
		
	texture := self proceduralSkySunDirection: sunDirection.
material
	skyTexture: (texture asSRGBTextureFor: model engine).
		
	model openWith: WDAFPSSceneView.

]

{ #category : #examples }
WDASceneExamples class >> example05DangerousPool [
	| model scene camera engine skyMaterial sunLight view magnumMesh pickedGun animationState gunAction gunActionFrame gunActionRepeated |
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera farDistance: 100.0.
	camera translateToX: 0.0 y: 1.0 z: -4.0.
	engine := scene engine.
	
	self constructPoolSceneInto: scene.
	
	"Add a light"
	sunLight := WDSGLightSource new.
	sunLight
		directional;
		castShadows: true;
		intensity: (WMVector4F x: 1.0 y: 1.0 z: 0.8) normalized * 0.8;
		rotateDegreesOnX: -45;
		translateToX: 0.0 y: 1.5 z: 2.5.
		
	scene add: sunLight.
		
	"Add the sky box"
	skyMaterial := engine resourceCache loadMaterial: 'materials/demos/skybox.json'.
	scene createSkyWithCubeTexture: skyMaterial skyTexture.
	scene ambientLighting: WMVector4F ones.
		
	magnumMesh := engine resourceCache loadMesh: 'models/demos/magnum_fps.fmdl'.
	
	pickedGun := WDSGSpatialObject new.
	pickedGun renderable: magnumMesh.
	camera addChild: pickedGun.

	animationState := magnumMesh deformationState.
	gunAction := animationState actionNamed: 'Draw'.
	gunActionFrame := 0.0.
	gunActionRepeated := false.
	
	model onDeltaTimeDo: [ :delta |
		gunActionFrame := gunActionFrame + (delta *30.0).
		animationState
			setRestPose;
			addAction: gunAction repeated: gunActionRepeated frame: gunActionFrame;
			computePoseMatrices.
		(gunActionRepeated not and: [ gunActionFrame > 35 ]) ifTrue: [
			gunAction := pickedGun renderable actions at: 'Idle'.
			gunActionFrame := 0.
			gunActionRepeated := true.
		]
	].
	
	view := WDAFPSSceneView allowingVR.
	view cameraAngle: (WMVector3F y: Float pi).
	model openWith: view.
]

{ #category : #examples }
WDASceneExamples class >> example06MeshGrid [
	| model meshBuilder mesh cube light scene camera material |
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera translateByZ: 3.0.
	
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
	light
		point;
		intensity: Color yellow asWMVector4F;
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.

	model openWith: WDAFPSSceneView.
]

{ #category : #examples }
WDASceneExamples class >> example07SmallTerrain [
	| model material mesh terrain light scene camera heightMap cube |
	
	"Some procedural textures used by the demo"
	heightMap := WDCTextureData extent: 128@128 signedHeightRenderWith: [ :s :t |
		|st|
		st := s@t.
		st*3.0 fractionalBrownianMotionOctaves: 5 lacunarity: 1.45 with: [ :c : a|
			(c signedGradientNoise *a) abs
		]
	].
	
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera farDistance: 100.0.
	camera translateByZ: 3.0; translateByY: 1.0.

	material := WDCTerrainMaterial for: scene engine.
	mesh := (WDCTerrainMeshBuilder for: scene engine)
		material: material;
		minHeight: 0.0;
		maxHeight: 8.0;
		createGridWithSize: (WMVector2F x: 20.0 y: 20.0) subdivisions: 128;
		terrainMesh.
	mesh deformationState
		heightMapScale: (WMVector2F x: 1.0 y: 1.0)/10.0;
		heightScale: 8.0;
		heightMapTexture: (heightMap asTextureFor: scene engine).
		
	terrain := WDSGSpatialObject new.
	terrain translateByY: -1.0.
	terrain renderable: mesh.
	
	cube := WDSGSpatialObject new.
	cube renderable: ((WDCGenericMeshBuilder for: scene engine)
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		mesh).
	cube translateByY: 3.0.	
	scene add: cube.
	
	scene add: terrain.
	
	light := WDSGLightSource new.
	light directional; castShadows: true.
	light 
		intensity: (Color fromHexString: 'f1efd7') asWMVector4F;
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
		st*10.0 fractionalBrownianMotionOctaves: 8 lacunarity: 1.45 with: [ :c : a|
			(c signedGradientNoise *a) abs
		]
	]] valueCachedInDisk.
	
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera farDistance: 200.0.
	camera translateByZ: 3.0; translateByY: 1.0.

	material := WDCTerrainMaterial for: scene engine.
	mesh := (WDCTerrainMeshBuilder for: scene engine)
		material: material;
		maxHeight: 8.0;
		createClipMapWithLevels: 3 size: (WMVector2F x: 20.0 y: 20.0) subdivisions: 128;
		terrainMesh.
	mesh deformationState
		heightMapScale: (WMVector2F x: 1.0 y: 1.0)/100.0;
		heightScale: 8.0;
		heightMapTexture: (heightMap asTextureFor: scene engine).
		
	terrain := WDSGSpatialObject new.
	terrain transform translateByY: -1.0.
	terrain renderable: mesh.
	scene add: terrain.
	
	light := WDSGLightSource new.
	light
		directional;
		castShadows: true;
		intensity: (Color fromHexString: 'f1efd7') asWMVector4F;
		rotateDegreesOnX: -45;
		rotateDegreesOnY: 135;
		translateToX: 0.0 y: 1.5 z: 2.5.
	scene add: light.

	model openWith: WDAFPSSceneView allowingVR.
]

{ #category : #examples }
WDASceneExamples class >> example09DragonIsland [
	| model terrain scene camera water dragonMesh dragon dragonAction dragonActionRepeated dragonActionFrame sunLight skyTexture dragonAnimationState |
	
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera farDistance: 250.0.
	camera translateByZ: 85.0; translateByY: 1.5.
	
	sunLight := WDSGLightSource new.
	sunLight directional; castShadows: true;
		shadowMapDepthBiasConstant: 20.0;
		shadowMapDepthBiasSlope: 5.0;
		intensity: (Color fromHexString: 'f1efd7') asWMVector4F*0.6;
		rotateDegreesOnX: -35;
		translateToX: 0.0 y: 1.5 z: 2.5.
	scene add: sunLight.
	
	skyTexture := self proceduralSkySunDirection: (sunLight transform transformVector3: (WMVector3F z: 1.0)).
	skyTexture := skyTexture asSRGBTextureFor: model engine.
	scene createSkyWithCubeTexture: skyTexture.
	scene ambientLighting: WMVector4F ones.

	terrain := self createIslandTerrainObjectFor: scene engine.
	scene add: terrain.

	water := self createIslandWaterObjectFor: scene engine.
	scene add: water.
	
	dragonMesh := scene engine resourceCache loadMesh: 'models/demos/baby_dragon.fmdl'.
	dragon := WDSGSpatialObject new.
	dragon renderable: dragonMesh.
	dragon transform
		rotateDegreesOnY: -45.0; 
		translateByZ: 70.0;
		translateByY: 3.0.

	scene add: dragon.
	
	dragonAnimationState := dragonMesh deformationState.
	dragonAction := dragonAnimationState actionNamed: 'Idle'.
	dragonActionRepeated := true.
	dragonActionFrame := 0.0.
	model onDeltaTimeDo: [ :delta |
		dragonActionFrame := dragonActionFrame + (delta *30.0).
		dragonAnimationState
			setRestPose;
			addAction: dragonAction repeated: dragonActionRepeated frame: dragonActionFrame;
			computePoseMatrices.
	].

	model openWith: WDAFPSSceneView allowingVR
]

{ #category : #examples }
WDASceneExamples class >> example10ParticleSystem [
	| model meshBuilder mesh cube light scene camera particleSystemRenderable particleSystem engine colorRamp |
	model := WDASampleSceneModel new.
	scene := model newScene.
	engine := model engine.
	camera := model camera.
	camera transform translateByX: 0.0 y: 1.0 z: 3.0.
	
	meshBuilder := WDCComplexGenericMeshBuilder for: scene engine.
	meshBuilder
		translateToX: 0.0 y: 0.5 z: 0.0;
		addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
		translateToX: 0.0 y: -0.25 z: 0.0;
		addCubeWithWidth: 10.0 height: 0.5 depth: 10.0.
	mesh := meshBuilder mesh.
	
	cube := WDSGSpatialObject new.
	cube renderable: mesh.
	scene add: cube.
	
	light := WDSGLightSource new.
	light
		point;
		intensity: (WMVector4F x: 1.0 y: 1.0 z: 0.9) normalized * 0.8;
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.

	"Particle system"
	colorRamp := WDCLinearRamp with: {
		0.0 -> '000000' asColor asWMVector3F asWMVector4F.
		0.6 -> 'ff0000' asColor asWMVector3F asWMVector4F.
		0.90 -> 'ffff00' asColor asWMVector3F asWMVector4F.
		1.0 -> 'ffff80' asColor asWMVector3F asWMVector4F.
	}.

	particleSystemRenderable := WDCParticleSystemRenderable new.
	particleSystemRenderable boundingBox: (WMBox3DF halfExtent: (WMVector3F ones*5.0)).
	particleSystemRenderable particleCount: (WDCEngine gpuBasedParticleSimulation
		ifTrue: [ 10000 ]
		ifFalse: [ 2000 ]).
	particleSystemRenderable simulationBlock: [ :particleState :index :delta |
		| lifeTime color flickering |
		lifeTime := particleState lifeTime  - delta.
		lifeTime <= 0.0 ifTrue:[
			lifeTime := 1.7 + particleState nextRandom*1.5.
			particleState
				startingUp: false;
				position: particleState nextRandomVector3F * 0.25;
				velocity: (WMVector3F
					x: particleState nextRandom*0.5
					y: 2.0 + (particleState nextRandom *0.5)
					z: particleState nextRandom*0.5).
		].
	
		color := colorRamp value: lifeTime / 3.0.
		flickering := (lifeTime*25.0) signedGradientNoise  *0.4 + 0.6.
		
		particleState
			size: (WMVector3F x: 0.2 y: 0.2);
			velocity: (particleState velocity + (WMVector3F y: -9.8 * delta*0.04));
			position: (particleState position + (particleState velocity *delta));
			color: color * flickering;
			lifeTime: lifeTime.
	].

	particleSystem := WDSGSpatialObject new.
	particleSystem renderable: particleSystemRenderable.
	particleSystem translateByY: 0.5.
	scene add: particleSystem.

	model openWith: WDAFPSSceneView.
]

{ #category : #'example models' }
WDASceneExamples class >> exampleModelBabyDragon [
	(WDCEngine default resourceCache load3DModel: 'models/demos/baby_dragon.fmdl') openViewer
]

{ #category : #'example models' }
WDASceneExamples class >> exampleModelBunny [
	(WDCEngine default resourceCache load3DModel: 'models/stanford/bun_zipper.ply') openViewer
]

{ #category : #'example models' }
WDASceneExamples class >> exampleModelCube [
	(WDCEngine default resourceCache load3DModel: 'models/obj/cube.obj') openViewer
]

{ #category : #'example models' }
WDASceneExamples class >> exampleModelDamagedHelmet [
	(WDCEngine default resourceCache load3DModel: 'models/glTF-Samples/DamagedHelmet/DamagedHelmet.glb') openViewer
]

{ #category : #'example models' }
WDASceneExamples class >> exampleModelSponza [
	| sceneModel sponzaModel scene camera light moonLight |
	sceneModel := WDASampleSceneModel new.

	sponzaModel := WDCAbstractModelLoader loadFromFile: (WodenCoreAssets location resolve: 'models/glTF-Samples/Sponza/glTF/Sponza.gltf').
	scene := sponzaModel mainScene.
	sceneModel scene: scene.
	
	scene backgroundColor: Color black.
	scene ambientLighting: WMVector4F ones*0.05.
	scene initializeWithEngine: sceneModel engine.
	
	camera := WDSGCamera new.
	scene add: camera.
	sceneModel camera: camera.
	
	camera transform translateByY: 0.5.
	
	moonLight := WDSGLightSource new.
	moonLight
		directional;
		intensity: (WMVector4F x: 1.0 y: 1.0 z: 0.8) normalized * 0.3;
		rotateDegreesOnX: -35.
		
	scene add: moonLight.

	{
		WMVector3F x: 3.9 y: 1.3 z: 1.18.
		WMVector3F x: 3.9 y: 1.3 z: -1.72.
		WMVector3F x: -4.95 y: 1.3 z: 1.18.
		WMVector3F x: -4.95 y: 1.3 z: -1.72.
	} do: [ :position |
		light := WDSGLightSource new.
		light point
			radius: 9.0;
			intensity: (WMVector4F ones)*2.5.
		light position: position.
		scene add: light.
	].
	
	sceneModel openWith: WDAFPSSceneView allowingVR.
]

{ #category : #'as yet unclassified' }
WDASceneExamples class >> proceduralSkySunDirection: sunDirection [
	| horizonRamp sunColor sunAngleSizeCos sunAngleSizeOuterCos shader |
	horizonRamp := WDCLinearRamp with: { 
		0.0 -> (Color fromHexString: '83b4dd').
		1.0 -> (Color fromHexString: '001c6f').
	}.
		
	sunColor := (Color fromHexString: 'f3f3e8') asWMVector4F.
		
	shader := [ :x :y :z |
		| direction background atmosphere clouds sunCos sunFactor |
		direction := (WMVector3F x: x y: y z: z) normalized.
		sunCos := direction dot: sunDirection.
		"sunAngleSizeCos := 0.5 degreesToRadians cos.
		sunAngleSizeOuterCos := 20.0 degreesToRadians cos."
		sunFactor := sunCos smoothStepFrom: 0.9396926207859084 to: 0.9999619230641713.

		atmosphere := horizonRamp value: direction y.

		clouds := 0.0.
		direction y > 0.0 ifTrue: [
			|t|
			t := 2.5 / direction y.
			clouds := (direction xz * t) fbmGradientNoiseOctaves: 4 lacunarity: 2.0.
			clouds := (clouds*2.0 - 1.0 max: 0.0) min: 1.0.
		
			clouds := clouds * (direction y smoothStepFrom: 0.0 to: 0.25)
		].
	
		background := atmosphere interpolateTo: (WMVector4F x: 1.0 y: 1.0 z: 1.0 w: 1.0) at: clouds.
		background interpolateTo: sunColor at: (sunFactor raisedTo: 8.0)
	].

	^ WDCPharoProceduralGPUScriptEvaluator new
		textureExtent: 512@512;
		cubeMap: true;
		colorFunction: shader;
		evaluate.
]

{ #category : #'see class side' }
WDASceneExamples >> seeClassSide [
]
