Class {
	#name : #WDAESProceduralSamples,
	#superclass : #Object,
	#category : #'WodenEngine-EntitySystem-Samples'
}

{ #category : #'as yet unclassified' }
WDAESProceduralSamples class >> addBalloonVehicleAt: balloonPosition toSector: sector [
	| balloonControlVolume kinematicBehavior driverPosition |
	sector addGenericObjectAt: balloonPosition with: [ :balloon |
		balloon makeKinematicPhysicsObject.
		kinematicBehavior := balloon addComponent: WDESBalloonVehicleKinematicPhysicsBehavior new.
		
		balloon addModelLibraryNamed: 'models/demos/vehicles/balloon.glb' nodeNamed: 'Balloon' with: [ :comp |
			comp createCollisionShapeWithConvexCollisionTreeNamed: 'BalloonCollisions'.
			
			balloonControlVolume := comp getChildNodeBoundingBox: 'Burner'.
			driverPosition := comp getChildNodePosition: 'DriverLocation'.
		].
		
		balloon addUseActuationBoxVolume: balloonControlVolume withAction: [ :sender :rayCastingTest |
			sender displacementStrategy: (WDESBalloonDrivingCharacterController new
				vehicle: balloon;
				vehicleKinematicBehavior: kinematicBehavior;
				localDriverPosition: driverPosition;
				yourself)
		].
	].

]

{ #category : #'as yet unclassified' }
WDAESProceduralSamples class >> example01SimpleLevel [
	| engine universe |
	engine := WDCEngine default.
	universe := WDESSimpleUniverse for: engine.
	universe buildSector: [ :sector |
		sector buildGenericMeshWith: [ :meshBuilder |
			meshBuilder
				translateToX: 0.0 y: -0.25 z: 0.0;
				addCubeWithWidth: 10.0 height: 0.5 depth: 10.0;
				addCollisionBox;
				
				translateToX: 0.0 y: 0.25 z: 0.0;
				addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;
				addCollisionBox
		].

		sector
			addPointLightAt: (Float32x3 x: 0.5 y: 1.0 z: 0.0) with: [ :light |
				light
					radius: 12.0;
					intensity: Float32x4 ones * 3.0
			];
			addPlayerStartPointAt: (Float32x3 x: 0.0 y: 2.0 z: 2.0)
	].

	universe createSimulationModel
		openInVR
		spawnPlayer.

]

{ #category : #'as yet unclassified' }
WDAESProceduralSamples class >> example02PoolLevel [
	| engine universe waterMaterial |
	engine := WDCEngine default.
	universe := WDESSimpleUniverse for: engine.
	universe defaultCameraToneMappingOperator: #filmic; defaultCameraFarDistance: 100.0.
	universe buildSector: [ :sector |
		sector buildGenericMeshWith: [ :meshBuilder |
			WDASceneExamples constructPoolMeshWith: meshBuilder.
		].

		sector
			addDirectionalLightWith: [ :light |
				| skyTexture |
				light
					castShadows: true;
					intensity: (Float32x4 x: 1.0 y: 1.0 z: 0.8) normalized * 0.7;
					rotateDegreesOnX: -35;
					rotateDegreesOnY: -180;
					translateToX: 0.0 y: 1.5 z: 2.5.
					
				skyTexture := WDASceneExamples proceduralSkySunDirection: light forwardDirection.
				skyTexture := skyTexture asTextureFor: engine.
				sector addSkyBoxWithTexture: skyTexture
			];
			addWaterVolumeAt: (Float32x3 y: -0.3) with: [ :waterVolume |
				(waterVolume buildWaterMeshWith: [ :meshBuilder |
				
					waterMaterial := engine resourceCache loadMaterial: 'materials/demos/water.wtmat'.
					meshBuilder
						material: waterMaterial;
						heightScale: 0.1;
						createGridWithSize: (Float32x2 x: 5.0 y: 5.0) subdivisions: 64;
						addCollisionBoxWithMinHeight: -2.0 maxHeight: 0.0
				]) renderable deformationState
					harmonicAt: 1 amplitude: 0.05 frequency: -1.1 center: Float32x2 new;
					harmonicAt: 2 amplitude: 0.02 frequency: 2.23 direction: (Float32x2 y: -1.0);
					harmonicAt: 3 amplitude: 0.015 frequency: 1.80 direction: (Float32x2 x: 1.0).
			];
		
			addRigidBodyAt: (Float32x3 x: -4.5 y: 0.6 z: 0.0) with: [ :rigidBody |
				rigidBody buildGenericMeshWith: [ :meshBuilder |
					meshBuilder
						addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
						addCollisionBox.
				].
			];

			addRigidBodyAt: (Float32x3 x: -4.2 y: 1.8 z: -0.4) with: [ :rigidBody |
				rigidBody buildGenericMeshWith: [ :meshBuilder |
					meshBuilder
						addCubeWithWidth: 0.6 height: 0.6 depth: 0.6;
						addCollisionBox.
				].
			];
		
			addPlayerStartPointAt: (Float32x3 x: -2.0 y: 2.0 z: 4.0)
	].

	universe createSimulationModel
		openInVR
		spawnPlayer.

]

{ #category : #'as yet unclassified' }
WDAESProceduralSamples class >> example03Island [
	| engine universe terrainMaterial waterMaterial terrainData |
	engine := WDCEngine default.
	terrainMaterial := engine resourceCache loadMaterial: 'materials/demos/island.wtmat'.
	terrainData := engine resourceCache loadTerrain: 'terrains/demos/procedural/island.stterrain'.

	universe := WDESSimpleUniverse for: engine.
	universe
		defaultCameraToneMappingOperator: #filmic;
		defaultCameraFarDistance: 250.0;
		defaultCameraCascadeSplitDistribution: 0.7.
	universe buildSector: [ :sector |
		sector buildTerrainMeshWithData: terrainData withMaterial: terrainMaterial.
		
		sector addWaterVolumeAt: Float32x3 zeros with: [ :waterVolume |
			(waterVolume buildWaterMeshWith: [ :meshBuilder |
				waterMaterial := engine resourceCache loadMaterial: 'materials/demos/ocean.wtmat'.
				meshBuilder material: waterMaterial.
				terrainData buildWaterMeshWith: meshBuilder.
				meshBuilder
					addCollisionBoxWithMinHeight: -200.0 maxHeight: 0.0 
			]) renderable deformationState
				harmonicAt: 1 amplitude: 0.015 frequency: 2.23 center: (Float32x2 zeros);
				harmonicAt: 2 amplitude: 0.03 frequency: 0.50 center: (Float32x2 zeros).
		].

		sector
			addDirectionalLightWith: [ :light |
				| skyTexture |
				light
					castShadows: true;
					intensity: (Float32x4 x: 1.0 y: 1.0 z: 0.8) normalized * 0.7;
					rotateDegreesOnX: -35;
					translateToX: 0.0 y: 1.5 z: 2.5.
					
				skyTexture := WDASceneExamples proceduralSkySunDirection: light forwardDirection.
				skyTexture := skyTexture asTextureFor: engine.
				sector addSkyBoxWithTexture: skyTexture
			];
		
			addPlayerStartPointAt: (Float32x3 x: 0.0 y: 2.0 z: 85.0)
	].

	universe createSimulationModel
		openInVR
		spawnPlayer.
]

{ #category : #'as yet unclassified' }
WDAESProceduralSamples class >> example04BalloonVehicle [
	| engine universe |
	engine := WDCEngine default.
	universe := WDESSimpleUniverse for: engine.
	universe defaultCameraToneMappingOperator: #filmic; defaultCameraFarDistance: 100.0.
	universe buildSector: [ :sector |
		sector buildGenericMeshWith: [ :meshBuilder |
			meshBuilder
				currentMaterial: (universe engine resourceCache loadMaterial: 'materials/procedural/terrain/sand.wtmat');
				translateToX: 0.0 y: -1.0 z: 0.0;
				addCubeWithWidth: 500.0 height: 2.0 depth: 500.0;
				planeTextureScale: (Float32x2 x: 0.1 y: 0.1) offset: (Float32x2 x: 0.0 y: 0.0);
				computeTangentsBitangents;
				addCollisionBox
		].
	
		self addBalloonVehicleAt: Float32x3 zeros toSector: sector.
	
		sector
			addDirectionalLightWith: [ :light |
				| skyTexture |
				light
					castShadows: true;
					intensity: (Float32x4 x: 1.0 y: 1.0 z: 0.8 w: 0.0) normalized * 0.7;
					rotateDegreesOnX: -45;
					rotateDegreesOnY: -180;
					translateToX: 0.0 y: 1.5 z: 2.5.
					
				skyTexture := WDASceneExamples proceduralSkySunDirection: light forwardDirection.
				skyTexture := skyTexture asTextureFor: engine.
				sector addSkyBoxWithTexture: skyTexture
			].
		
		sector
			addPlayerStartPointAt: (Float32x3 x: 0.0 y: 2.0 z: 10.0)
	].

	universe createSimulationModel
		openInVR
		spawnPlayer.

]

{ #category : #'world menu' }
WDAESProceduralSamples class >> menuCommandOn: builder [
	<worldMenu>
	(builder item: #'Browse entity system examples')
		parent: #Woden;
		order: 402;
		action: [ self class browse ].
]

{ #category : #'see class side' }
WDAESProceduralSamples >> seeClassSide [
]
