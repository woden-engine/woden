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

{ #category : #accessing }
WDCTerrainMeshDeformationState >> applyTerrainDataState [
	terrainStateData
		heightMapOffset: terrainData heightMapOffset;
		heightMapScale: terrainData heightMapScale;
		heightOffset: terrainData heightOffset;
		heightScale: terrainData heightScale
]

{ #category : #accessing }
WDCTerrainMeshDeformationState >> clipMapPeriod: clipMapPeriod [
	terrainStateData clipMapPeriod: (clipMapPeriod ifNil: [WMVector2F zero])
]

{ #category : #accessing }
WDCTerrainMeshDeformationState >> createEngineDependantData [
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

{ #category : #initialization }
WDCTerrainMeshDeformationState >> initialize [
	super initialize.
	terrainStateData := WDCTerrainDeformationStateStructure new
		heightMapScale: (WMVector2F x: 1.0 y: 1.0);
		heightMapOffset: WMVector2F zero;
		heightScale: 1.0;
		yourself.
	terrainData := WDCTerrainData new.

]

{ #category : #testing }
WDCTerrainMeshDeformationState >> isTerrainDeformationState [
	^ true
]

{ #category : #accessing }
WDCTerrainMeshDeformationState >> requiresAccessFromTheCPU [
	^ false
]

{ #category : #accessing }
WDCTerrainMeshDeformationState >> terrainData [
	^ terrainData
]

{ #category : #accessing }
WDCTerrainMeshDeformationState >> terrainData: anObject [
	terrainData := anObject.
	self applyTerrainDataState
]

{ #category : #accessing }
WDCTerrainMeshDeformationState >> terrainStateData [
	^ terrainStateData
]
