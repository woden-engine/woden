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
		heightScale: terrainData heightScale.
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
	terrainStateData clipMapPeriod: (clipMapPeriod ifNil: [WMVector2F zero])
]

{ #category : #resources }
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

{ #category : #dependencies }
WDCTerrainMeshDeformationState >> dependencyChange: dependency [
	dependency == terrainData ifTrue: [ self applyTerrainDataState ].
]

{ #category : #initialization }
WDCTerrainMeshDeformationState >> initialize [
	super initialize.
	terrainStateData := WDCTerrainDeformationStateStructure new
		heightMapScale: (WMVector2F x: 1.0 y: 1.0);
		heightMapOffset: WMVector2F zero;
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
