Class {
	#name : #WDCTerrainMeshDeformationState,
	#superclass : #WDCRenderableDeformationState,
	#instVars : [
		'terrainStateData',
		'heightMapTexture',
		'splattingTexture',
		'gpuTerrainState'
	],
	#category : #'WodenEngine-Core-Mesh'
}

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
			bind: 1 texture: (heightMapTexture ifNil: [engine resourceCache blackTexture]);
			bind: 2 texture: (splattingTexture ifNil: [engine resourceCache blackTexture])
	]
]

{ #category : #initialization }
WDCTerrainMeshDeformationState >> heightMapOffset: anOffset [
	terrainStateData heightMapScale: anOffset
]

{ #category : #initialization }
WDCTerrainMeshDeformationState >> heightMapScale: aScale [
	terrainStateData heightMapScale: aScale
]

{ #category : #accessing }
WDCTerrainMeshDeformationState >> heightMapTexture [
	^ heightMapTexture
]

{ #category : #accessing }
WDCTerrainMeshDeformationState >> heightMapTexture: anObject [
	heightMapTexture := anObject
]

{ #category : #initialization }
WDCTerrainMeshDeformationState >> heightOffset: anOffset [
	terrainStateData heightOffset: anOffset
]

{ #category : #initialization }
WDCTerrainMeshDeformationState >> heightScale: aScale [
	terrainStateData heightScale: aScale
]

{ #category : #initialization }
WDCTerrainMeshDeformationState >> initialize [
	super initialize.
	terrainStateData := WDCTerrainDeformationStateStructure new
		heightMapScale: (WMVector2F x: 1.0 y: 1.0);
		heightMapOffset: WMVector2F zero;
		heightScale: 1.0;
		yourself

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
WDCTerrainMeshDeformationState >> splattingTexture [
	^ splattingTexture
]

{ #category : #accessing }
WDCTerrainMeshDeformationState >> splattingTexture: anObject [
	splattingTexture := anObject
]

{ #category : #accessing }
WDCTerrainMeshDeformationState >> terrainStateData [
	^ terrainStateData
]
