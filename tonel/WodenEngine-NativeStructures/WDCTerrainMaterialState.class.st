Class {
	#name : #WDCTerrainMaterialState,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#albedo => Float32x4',
		'#metallicFactor => Float32',
		'#roughnessFactor => Float32',
		'#textureScaleAndOffset => (Float32x4 array: 5)'
	],
	#category : #'WodenEngine-NativeStructures-Core-Material'
}

{ #category : #accessing }
WDCTerrainMaterialState >> albedo [
	^ albedo
]

{ #category : #accessing }
WDCTerrainMaterialState >> albedo: anObject [
	albedo := anObject
]

{ #category : #accessing }
WDCTerrainMaterialState >> metallicFactor [
	^ metallicFactor
]

{ #category : #accessing }
WDCTerrainMaterialState >> metallicFactor: anObject [
	metallicFactor := anObject
]

{ #category : #accessing }
WDCTerrainMaterialState >> roughnessFactor [
	^ roughnessFactor
]

{ #category : #accessing }
WDCTerrainMaterialState >> roughnessFactor: anObject [
	roughnessFactor := anObject
]

{ #category : #accessing }
WDCTerrainMaterialState >> textureScaleAndOffset [
	^ textureScaleAndOffset
]

{ #category : #accessing }
WDCTerrainMaterialState >> textureScaleAndOffset: anObject [
	textureScaleAndOffset := anObject
]
