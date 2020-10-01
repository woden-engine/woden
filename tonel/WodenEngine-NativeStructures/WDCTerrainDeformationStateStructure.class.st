Class {
	#name : #WDCTerrainDeformationStateStructure,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#clipMapPeriod => Float32x2',
		'#cellSize => Float32x2',
		'#padding => Float32x2',
		'#heightMapScale => Float32x2',
		'#heightMapOffset => Float32x2',
		'#heightScale => Float32',
		'#heightOffset => Float32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Material'
}

{ #category : #accessing }
WDCTerrainDeformationStateStructure >> cellSize [
	^ cellSize
]

{ #category : #accessing }
WDCTerrainDeformationStateStructure >> cellSize: anObject [
	cellSize := anObject
]

{ #category : #accessing }
WDCTerrainDeformationStateStructure >> clipMapPeriod [
	^ clipMapPeriod
]

{ #category : #accessing }
WDCTerrainDeformationStateStructure >> clipMapPeriod: anObject [
	clipMapPeriod := anObject
]

{ #category : #accessing }
WDCTerrainDeformationStateStructure >> heightMapOffset [
	^ heightMapOffset
]

{ #category : #accessing }
WDCTerrainDeformationStateStructure >> heightMapOffset: anObject [
	heightMapOffset := anObject
]

{ #category : #accessing }
WDCTerrainDeformationStateStructure >> heightMapScale [
	^ heightMapScale
]

{ #category : #accessing }
WDCTerrainDeformationStateStructure >> heightMapScale: anObject [
	heightMapScale := anObject
]

{ #category : #accessing }
WDCTerrainDeformationStateStructure >> heightOffset [
	^ heightOffset
]

{ #category : #accessing }
WDCTerrainDeformationStateStructure >> heightOffset: anObject [
	heightOffset := anObject
]

{ #category : #accessing }
WDCTerrainDeformationStateStructure >> heightScale [
	^ heightScale
]

{ #category : #accessing }
WDCTerrainDeformationStateStructure >> heightScale: anObject [
	heightScale := anObject
]

{ #category : #accessing }
WDCTerrainDeformationStateStructure >> padding [
	^ padding
]

{ #category : #accessing }
WDCTerrainDeformationStateStructure >> padding: anObject [
	padding := anObject
]
