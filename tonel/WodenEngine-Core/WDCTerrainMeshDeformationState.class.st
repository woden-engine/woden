Class {
	#name : #WDCTerrainMeshDeformationState,
	#superclass : #WDCRenderableDeformationState,
	#instVars : [
		'terrainData',
		'terrainStateData',
		'gpuTerrainState'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #private }
WDCTerrainMeshDeformationState >> applyTerrainDataState [
	terrainStateData
		heightMapOffset: terrainData heightMapOffset;
		heightMapScale: terrainData heightMapScale;
		heightOffset: terrainData heightOffset;
		heightScale: terrainData heightScale;
		cellSize: terrainData terrainCellSize.
	renderableStateBindings ifNotNil: [ 
		renderableStateBindings do: [ :bindings |
			bindings
				bind: 1 texture: (terrainData heightMap ifNil: [engine resourceCache blackTexture]);
				bind: 2 texture: (terrainData splatterMap ifNil: [engine resourceCache blackTexture])
		]
	].
]

{ #category : #accessing }
WDCTerrainMeshDeformationState >> clipMapPeriod: clipMapPeriod [
	terrainStateData clipMapPeriod: (clipMapPeriod ifNil: [Float32x2 zeros])
]

{ #category : #resources }
WDCTerrainMeshDeformationState >> createEngineDependantData [
	engine isDummyEngine ifTrue: [ ^ self ].
	super createEngineDependantData.
	gpuTerrainState := (engine resourceCache streamingStorageBufferPoolFor: WDCTerrainDeformationStateStructure) allocate.
	gpuTerrainState value: terrainStateData.

	renderableStateBindings do: [ :bindings |
		bindings
			bind: 0 storageBufferElement: gpuTerrainState;
			bind: 1 texture: (terrainData heightMap ifNil: [engine resourceCache blackTexture]);
			bind: 2 texture: (terrainData splatterMap ifNil: [engine resourceCache blackTexture])
	]
]

{ #category : #dependencies }
WDCTerrainMeshDeformationState >> dependencyChange: dependency [
	dependency == terrainData ifTrue: [ self applyTerrainDataState ].
]

{ #category : #initialization }
WDCTerrainMeshDeformationState >> initialize [
	super initialize.
	terrainStateData := WDCTerrainDeformationStateStructure new
		heightMapScale: (Float32x2 x: 1.0 y: 1.0);
		heightMapOffset: Float32x2 zeros;
		heightScale: 1.0;
		yourself.
	self terrainData: WDCTerrainData new.

]

{ #category : #testing }
WDCTerrainMeshDeformationState >> isTerrainDeformationState [
	^ true
]

{ #category : #resources }
WDCTerrainMeshDeformationState >> requiresAccessFromTheCPU [
	^ false
]

{ #category : #accessing }
WDCTerrainMeshDeformationState >> terrainData [
	^ terrainData
]

{ #category : #accessing }
WDCTerrainMeshDeformationState >> terrainData: anObject [
	terrainData ifNotNil: [ terrainData removeWodenResourceDependant: self ].
	terrainData := anObject.
	terrainData ifNotNil: [ terrainData addWodenResourceDependant: self ].
	self applyTerrainDataState
]

{ #category : #accessing }
WDCTerrainMeshDeformationState >> terrainStateData [
	^ terrainStateData
]
