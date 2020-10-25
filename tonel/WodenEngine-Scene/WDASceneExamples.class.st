Class {
	#name : #WDASceneExamples,
	#superclass : #Object,
	#category : #'WodenEngine-Scene-Examples'
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
		planeTextureScale: (Float32x2 x: 2.0 y: 2.0) offset: (Float32x2 x: 0.0 y: 0.0);
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
		createGridWithSize: (Float32x2 x: 5.0 y: 5.0) subdivisions: 64;
		waterMesh.
	waterMesh deformationState
		harmonicAt: 1 amplitude: 0.05 frequency: -1.1 center: Float32x2 new;
		harmonicAt: 2 amplitude: 0.02 frequency: 2.23 direction: (Float32x2 y: -1.0);
		harmonicAt: 3 amplitude: 0.015 frequency: 1.80 direction: (Float32x2 x: 1.0).
		
	waterSurface := WDSGSpatialObject new.
	waterSurface
		renderable: waterMesh;
		translateToX: 0.0 y: -0.3 z: 0.0.
	scene add: waterSurface.
]

{ #category : #'examples procedural' }
WDASceneExamples class >> createIslandTerrainObjectFor: engine [
	| material mesh terrain terrainData |
	material := engine resourceCache loadMaterial: 'materials/demos/island.json'.
	terrainData := engine resourceCache loadTerrain: 'terrains/demos/procedural/island.stterrain'.
	
	terrain := WDSGSpatialObject new.
	mesh := terrainData createTerrainMeshWithMaterial: material.
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
		createClipMapWithLevels: 3 size: (Float32x2 x: 40.0 y: 40.0) subdivisions: 128;
		waterMesh.

	mesh deformationState
		harmonicAt: 1 amplitude: 0.015 frequency: 2.23 center: (Float32x2 zeros);
		harmonicAt: 2 amplitude: 0.03 frequency: 0.50 center: (Float32x2 zeros).

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
		intensity: Color yellow asFloat32x4 * 5.0;
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
		intensity: Color yellow asFloat32x4;
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
		planeTextureScale: (Float32x2 x: 2.0 y: 2.0) offset: (Float32x2 x: 0.0 y: 0.0);
		computeTangentsBitangents.
	mesh := meshBuilder mesh.
	
	cube := WDSGSpatialObject new.
	cube renderable: mesh.
	scene add: cube.
	
	light := WDSGLightSource new.
	light
		point;
		intensity: (Float32x4 x: 1.0 y: 1.0 z: 0.3 w: 1.0) * 0.8;
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
		toneMappingOperator: #filmic;
		farDistance: 100.0.
	camera translateToX: 0.0 y: 1.0 z: -4.0.
	
	self constructPoolSceneInto: scene.


	"Add a light"
	sunLight := WDSGLightSource new.
	sunLight
		directional;
		castShadows: true;
		intensity: (Float32x4 x: 1.0 y: 1.0 z: 0.8) normalized * 0.7;
		rotateDegreesOnX: -35;
		translateToX: 0.0 y: 1.5 z: 2.5.

	scene add: sunLight.

	scene ambientLighting: Float32x4 ones.

	"Create the sky."
	skyTexture := self proceduralSkySunDirection: (sunLight transform transformVector: (Float32x3 z: 1.0)).
	skyTexture := skyTexture asTextureFor: engine.
	scene createSkyWithCubeTexture: skyTexture.

	view := WDAFPSSceneView allowingVR.
	model openWith: view.
]

{ #category : #examples }
WDASceneExamples class >> example04ProceduralSky [
	| model scene camera meshBuilder mesh cube sunDirection skyTexture sunLight |
	model := WDASampleSceneModel new.
	scene := model newScene.

	camera := model camera.
	camera translateByY: 1.7.
	
	meshBuilder := WDCGenericMeshBuilder for: scene engine.
	meshBuilder
		defaultMaterial;
		addCubeWithWidth: 10.0 height: 0.5 depth: 10.0.
	mesh := meshBuilder mesh.
	
	cube := WDSGSpatialObject new.
	cube renderable: mesh.
	scene add: cube.
	
	sunLight := WDSGLightSource new.
	sunLight
		directional;
		castShadows: true;
		intensity: (Float32x4 x: 1.0 y: 1.0 z: 0.8) normalized * 0.7;
		rotateDegreesOnX: -45;
		translateToX: 0.0 y: 1.5 z: 2.5.
		
	sunDirection := sunLight transform transformVector: (Float32x3 z: 1.0).
		
	"Create the sky."
	skyTexture := self proceduralSkySunDirection: sunDirection.
	skyTexture := skyTexture asTextureFor: scene engine.
	scene createSkyWithCubeTexture: skyTexture.
	scene ambientLighting: Float32x4 ones.
		
	model openWith: WDAFPSSceneView.

]

{ #category : #examples }
WDASceneExamples class >> example05DangerousPool [
	| model scene camera engine skyTexture sunLight view foxModel fox foxAnimationState walkAnimation animationTime foxScale movementTime animationDilationFactor |
	model := WDASampleSceneModel new.
	scene := model newScene.
	camera := model camera.
	camera
		toneMappingOperator: #filmic;
		farDistance: 100.0;
		translateToX: 0.0 y: 1.0 z: -4.0.
	engine := scene engine.
	
	self constructPoolSceneInto: scene.
	
	"Add a light"
	sunLight := WDSGLightSource new.
	sunLight
		directional;
		castShadows: true;
		intensity: (Float32x4 x: 1.0 y: 1.0 z: 0.8) normalized * 0.8;
		rotateDegreesOnX: -45;
		translateToX: 0.0 y: 1.5 z: 2.5.
		
	scene add: sunLight.
	scene ambientLighting: Float32x4 ones.
		
	"Create the sky."
	skyTexture := self proceduralSkySunDirection: (sunLight transform transformVector: (Float32x3 z: 1.0)).
	skyTexture := skyTexture asTextureFor: engine.
	scene createSkyWithCubeTexture: skyTexture.
		
	foxModel := engine resourceCache load3DModel: 'models/glTF-Samples/Fox/Fox.gltf'.

	fox := foxModel instanceSceneNodeNamed: 'fox'.
	foxScale := 0.015f.
	fox scaleBy: foxScale.
	scene add: fox.
	
	foxAnimationState := fox renderable deformationState.
	walkAnimation := foxModel getAnimationNamed: 'Walk'.

	movementTime := 0.0.
	animationTime := 0.0.
	model onDeltaTimeDo: [ :delta |
		| angle omega period speed radius animationWalkSpeed |

		period := 30.0.
		radius := 5.5.
		omega := Float twoPi / period.

		speed := omega * radius.
		animationWalkSpeed := 2.0.
		animationDilationFactor := speed / animationWalkSpeed.

		movementTime := movementTime + delta.
		animationTime := animationTime + (delta * animationDilationFactor).

		angle := omega * movementTime.
		fox transform: (ReversibleAffineTransform3dF32 identity
			scaleBy: foxScale;
			rotateRadiansOnY: angle + Float pi;
			translation: (Float32x3 x: radius * angle cos y: 0 z: radius*angle sin negated);
			yourself).

		foxAnimationState
			setRestPose;
			applyAnimation: walkAnimation repeated: true inTime: animationTime;
			computePoseMatrices.
	].
	
	view := WDAFPSSceneView allowingVR.
	view cameraAngle: (Float32x3 y: Float pi).
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
		intensity: Color yellow asFloat32x4;
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.

	model openWith: WDAFPSSceneView.
]

{ #category : #examples }
WDASceneExamples class >> example07SmallTerrain [
	| model material terrain light scene camera terrainData cube |

	"Some procedural textures used by the demo"
	terrainData := WDCTerrainData textureExtent: 128@128 heightRenderWith: [ :s :t |
		|st|
		st := s@t.
		st*3.0 fractionalBrownianMotionOctaves: 5 lacunarity: 1.45 with: [ :c : a|
			(c signedGradientNoise *a) abs
		]
	].

	model := WDASampleSceneModel new.
	terrainData
		engine: model engine;
		terrainExtent: 20@20;
		minHeight: 0;
		maxHeight: 8.0.
	
	scene := model newScene.
	camera := model camera.
	camera farDistance: 100.0.
	camera translateByZ: 3.0; translateByY: 1.0.

	material := WDCTerrainMaterial for: scene engine.

	terrain := WDSGSpatialObject new.
	terrain translateByY: -1.0.
	terrain renderable: (terrainData createTerrainMeshWithMaterial: material).
	
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
		intensity: (Color fromHexString: 'f1efd7') asFloat32x4;
		rotateDegreesOnX: -45;
		rotateDegreesOnY: 135;
		translateToX: 0.0 y: 1.5 z: 2.5.
	scene add: light.

	model openWith: WDAFPSSceneView.
]

{ #category : #examples }
WDASceneExamples class >> example08MediumTerrain [
	| model material terrain light scene camera terrainData |
	
	"Some procedural textures used by the demo"
	terrainData := [WDCTerrainData textureExtent: 256@256 heightRenderWith: [ :s :t |
		|st|
		st := s@t.
		st*10.0 fractionalBrownianMotionOctaves: 8 lacunarity: 1.45 with: [ :c : a|
			(c signedGradientNoise *a) abs
		]
	]] valueCachedInDisk.
	
	
	model := WDASampleSceneModel new.
	terrainData
		clipMapLevels: 3;
		engine: model engine;
		terrainExtent: 200@200;
		minHeight: 0;
		maxHeight: 8.0.

	scene := model newScene.
	camera := model camera.
	camera farDistance: 200.0.
	camera translateByZ: 3.0; translateByY: 1.0.

	material := WDCTerrainMaterial for: scene engine.
	terrain := WDSGSpatialObject new.
	terrain transform translateByY: -1.0.
	terrain renderable: (terrainData createTerrainMeshWithMaterial: material).
	scene add: terrain.
	
	light := WDSGLightSource new.
	light
		directional;
		castShadows: true;
		intensity: (Color fromHexString: 'f1efd7') asFloat32x4;
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
	camera toneMappingOperator: #filmic.
	camera farDistance: 250.0; cascadeSplitDistribution: 0.75.
	camera translateByZ: 85.0; translateByY: 1.5.
	
	sunLight := WDSGLightSource new.
	sunLight directional; castShadows: true;
		shadowMapDepthBiasConstant: 20.0;
		shadowMapDepthBiasSlope: 5.0;
		intensity: (Color fromHexString: 'f1efd7') asFloat32x4*0.6;
		rotateDegreesOnX: -35;
		translateToX: 0.0 y: 1.5 z: 2.5.
	scene add: sunLight.
	
	skyTexture := self proceduralSkySunDirection: (sunLight transform transformVector: (Float32x3 z: 1.0)).
	skyTexture := skyTexture asTextureFor: model engine.
	scene createSkyWithCubeTexture: skyTexture.
	scene ambientLighting: Float32x4 ones.

	terrain := self createIslandTerrainObjectFor: scene engine.
	scene add: terrain.

	water := self createIslandWaterObjectFor: scene engine.
	scene add: water.
	
	"dragonMesh := scene engine resourceCache loadMesh: 'models/demos/baby_dragon.fmdl'.
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
	]."

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
		intensity: (Float32x4 x: 1.0 y: 1.0 z: 0.9) normalized * 0.8;
		translateByX: -1.5 y: 1.5 z: 1.6.
	scene add: light.

	"Particle system"
	colorRamp := WDCLinearRamp with: {
		0.0 -> '000000' asColor asFloat32x3 asFloat32x4.
		0.6 -> 'ff0000' asColor asFloat32x3 asFloat32x4.
		0.90 -> 'ffff00' asColor asFloat32x3 asFloat32x4.
		1.0 -> 'ffff80' asColor asFloat32x3 asFloat32x4.
	}.

	particleSystemRenderable := WDCParticleSystemRenderable new.
	particleSystemRenderable boundingBox: (BoxF32 halfExtent: (Float32x3 ones*5.0)).
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
				velocity: (Float32x3
					x: particleState nextRandom*0.5
					y: 2.0 + (particleState nextRandom *0.5)
					z: particleState nextRandom*0.5).
		].
	
		color := colorRamp value: lifeTime / 3.0.
		flickering := (lifeTime*25.0) signedGradientNoise  *0.4 + 0.6.
		
		particleState
			size: (Float32x3 x: 0.2 y: 0.2);
			velocity: (particleState velocity + (Float32x3 y: -9.8 * delta*0.04));
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
WDASceneExamples class >> exampleModelBalloon [
	(WDCEngine default resourceCache load3DModel: 'models/demos/decoration/foil-balloon.glb') openViewer
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
WDASceneExamples class >> exampleModelFox [
	(WDCEngine default resourceCache load3DModel: 'models/glTF-Samples/Fox/Fox.gltf') createViewer
		scaleBy: 0.015f;
		setCameraPosition: (Float32x3 x: 0 y: 1.6 z: 3);
		setCameraFarDistance: 50.0;
		addCube: (BoxF32 center: (Float32x3 y: -0.25f) halfExtent: (Float32x3 x: 3 y: 0.25 z: 3));
		playAnimationNamed: 'Survey';
		castShadows: true;
		open
]

{ #category : #'example models' }
WDASceneExamples class >> exampleModelSponza [
	| sceneModel sponzaModel scene camera light moonLight |
	sceneModel := WDASampleSceneModel new.

	sponzaModel :=(WDCEngine default resourceCache load3DModel: 'models/glTF-Samples/Sponza/glTF/Sponza.gltf').
	scene := sponzaModel mainScene copy.
	sceneModel scene: scene.
	
	scene backgroundColor: Color black.
	scene ambientLighting: Float32x4 ones*0.05.
	scene initializeWithEngine: sceneModel engine.
	
	camera := WDSGCamera new.
	scene add: camera.
	sceneModel camera: camera.
	
	camera transform translateByY: 0.5.
	
	moonLight := WDSGLightSource new.
	moonLight
		directional;
		intensity: (Float32x4 x: 1.0 y: 1.0 z: 0.8) normalized * 0.3;
		rotateDegreesOnX: -35.
		
	scene add: moonLight.

	{
		Float32x3 x: 3.9 y: 1.3 z: 1.18.
		Float32x3 x: 3.9 y: 1.3 z: -1.72.
		Float32x3 x: -4.95 y: 1.3 z: 1.18.
		Float32x3 x: -4.95 y: 1.3 z: -1.72.
	} do: [ :position |
		light := WDSGLightSource new.
		light point
			radius: 9.0;
			intensity: (Float32x4 ones)*2.5.
		light position: position.
		scene add: light.
	].
	
	sceneModel openWith: WDAFPSSceneView allowingVR.
]

{ #category : #'world menu' }
WDASceneExamples class >> menuCommandOn: builder [
	<worldMenu>
	(builder item: #'Browse scene examples')
		parent: #Woden;
		order: 400;
		action: [ self class browse ].
]

{ #category : #'as yet unclassified' }
WDASceneExamples class >> proceduralSkySunDirection: sunDirection [
	| horizonRamp sunColor sunAngleSizeCos sunAngleSizeOuterCos shader |
	horizonRamp := WDCLinearRamp with: {
		0.0 -> (Color fromHexString: '83b4dd').
		1.0 -> (Color fromHexString: '001c6f').
	}.
		
	sunColor := (Color fromHexString: 'f3f3e8') asFloat32x4.
	sunAngleSizeCos := 0.5 degreesToRadians cos.
	sunAngleSizeOuterCos := 20.0 degreesToRadians cos.
		
	shader := [ :x :y :z |
		| direction background atmosphere clouds sunCos sunFactor |
		direction := (Float32x3 x: x y: y z: z) normalized.
		sunCos := direction dot: sunDirection.
		sunFactor := sunCos smoothStepFrom: sunAngleSizeOuterCos to: sunAngleSizeCos.

		atmosphere := horizonRamp value: direction y.

		clouds := 0.0.
		direction y > 0.0 ifTrue: [
			|t|
			t := 2.5 / direction y.
			clouds := (direction xz * t) fbmGradientNoiseOctaves: 4 lacunarity: 2.0.
			clouds := (clouds*2.0 - 1.0 max: 0.0) min: 1.0.
		
			clouds := clouds * (direction y smoothStepFrom: 0.0 to: 0.25)
		].
	
		background := atmosphere interpolateTo: (Float32x4 x: 1.0 y: 1.0 z: 1.0 w: 1.0) at: clouds.
		background interpolateTo: sunColor at: (sunFactor raisedTo: 8.0)
	].

	^ WDCPharoProceduralGPUScriptEvaluator new
		textureExtent: 512@512;
		skyCubeMap: true;
		colorFunction: shader;
		evaluate.
]

{ #category : #'see class side' }
WDASceneExamples >> seeClassSide [
]
