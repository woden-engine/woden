Class {
	#name : #WDAESProceduralSamples,
	#superclass : #Object,
	#category : #'WodenEngine-EntitySystem-Samples'
}

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
			addPointLightAt: (WMVector3F x: 0.5 y: 1.0 z: 0.0) with: [ :light |
				light
					radius: 12.0;
					intensity: WMVector4F ones * 3.0
			];
			addPlayerStartPointAt: (WMVector3F x: 0.0 y: 2.0 z: 2.0)
	].

	universe createSimulationModel
		open
		spawnPlayer.

]

{ #category : #'as yet unclassified' }
WDAESProceduralSamples class >> example02PoolLevel [
	| engine universe waterMaterial |
	engine := WDCEngine default.
	universe := WDESSimpleUniverse for: engine.
	universe defaultCameraFarDistance: 100.0.
	universe buildSector: [ :sector |
		sector buildGenericMeshWith: [ :meshBuilder |
			WDASceneExamples constructPoolMeshWith: meshBuilder.
		].

		sector
			addDirectionalLightWith: [ :light |
				| skyTexture |
				light
					castShadows: true;
					intensity: (WMVector4F x: 1.0 y: 1.0 z: 0.8) normalized * 0.7;
					rotateDegreesOnX: -35;
					rotateDegreesOnY: -180;
					translateToX: 0.0 y: 1.5 z: 2.5.
					
				skyTexture := WDASceneExamples proceduralSkySunDirection: light forwardDirection.
				skyTexture := skyTexture asSRGBTextureFor: engine.
				sector addSkyBoxWithTexture: skyTexture
			];
			addWaterVolumeAt: (WMVector3F y: -0.3) with: [ :waterVolume |
				(waterVolume buildWaterMeshWith: [ :meshBuilder |
				
					waterMaterial := engine resourceCache loadMaterial: 'materials/demos/water.json'.
					meshBuilder
						material: waterMaterial;
						heightScale: 0.1;
						createGridWithSize: (WMVector2F x: 5.0 y: 5.0) subdivisions: 64;
						addCollisionBoxWithMinHeight: -2.0 maxHeight: 0.0
				]) renderable deformationState
					harmonicAt: 1 amplitude: 0.05 frequency: -1.1 center: WMVector2F new;
					harmonicAt: 2 amplitude: 0.02 frequency: 2.23 direction: (WMVector2F y: -1.0);
					harmonicAt: 3 amplitude: 0.015 frequency: 1.80 direction: (WMVector2F x: 1.0).
			];
		
			addRigidBodyAt: (WMVector3F x: -4.5 y: 0.6 z: 0.0) with: [ :rigidBody |
				rigidBody buildGenericMeshWith: [ :meshBuilder |
					meshBuilder
						addCubeWithWidth: 1.0 height: 1.0 depth: 1.0;
						addCollisionBox.
				].
			];

			addRigidBodyAt: (WMVector3F x: -4.2 y: 1.8 z: -0.4) with: [ :rigidBody |
				rigidBody buildGenericMeshWith: [ :meshBuilder |
					meshBuilder
						addCubeWithWidth: 0.6 height: 0.6 depth: 0.6;
						addCollisionBox.
				].
			];
		
			addPlayerStartPointAt: (WMVector3F x: -2.0 y: 2.0 z: 4.0)
	].

	universe createSimulationModel
		open
		spawnPlayer.

]

{ #category : #'as yet unclassified' }
WDAESProceduralSamples class >> example03Island [
	| engine universe terrainMaterial waterMaterial terrainData |
	engine := WDCEngine default.
	terrainMaterial := engine resourceCache loadMaterial: 'materials/demos/island.json'.
	terrainData := engine resourceCache loadTerrain: 'terrains/demos/procedural/island.stterrain'.

	universe := WDESSimpleUniverse for: engine.
	universe defaultCameraFarDistance: 250.0; defaultCameraCascadeSplitDistributionLambda: 0.7.
	universe buildSector: [ :sector |
		sector buildTerrainMeshWithData: terrainData withMaterial: terrainMaterial.
		
		sector addWaterVolumeAt: WMVector3F zero with: [ :waterVolume |
			(waterVolume buildWaterMeshWith: [ :meshBuilder |
				waterMaterial := engine resourceCache loadMaterial: 'materials/demos/ocean.json'.
				meshBuilder material: waterMaterial.
				terrainData buildWaterMeshWith: meshBuilder.
				meshBuilder
					addCollisionBoxWithMinHeight: -200.0 maxHeight: 0.0 
			]) renderable deformationState
				harmonicAt: 1 amplitude: 0.015 frequency: 2.23 center: (WMVector2F zero);
				harmonicAt: 2 amplitude: 0.03 frequency: 0.50 center: (WMVector2F zero).
		].

		sector
			addDirectionalLightWith: [ :light |
				| skyTexture |
				light
					castShadows: true;
					intensity: (WMVector4F x: 1.0 y: 1.0 z: 0.8) normalized * 0.7;
					rotateDegreesOnX: -35;
					translateToX: 0.0 y: 1.5 z: 2.5.
					
				skyTexture := WDASceneExamples proceduralSkySunDirection: light forwardDirection.
				skyTexture := skyTexture asSRGBTextureFor: engine.
				sector addSkyBoxWithTexture: skyTexture
			];
		
			addPlayerStartPointAt: (WMVector3F x: 0.0 y: 2.0 z: 85.0)
	].

	universe createSimulationModel
		open
		spawnPlayer.
]

{ #category : #'see class side' }
WDAESProceduralSamples >> seeClassSide [
]
