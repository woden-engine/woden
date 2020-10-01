Class {
	#name : #WDCWaterMaterialState,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#albedo => Float32x4',
		'#fresnel => Float32x3',
		'#smoothness => Float32',
		'#textureScale => Float32x2',
		'#textureOffset => Float32x2',
		'#padding => Float32x3',
		'#propagationSpeed => Float32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Material'
}

{ #category : #accessing }
WDCWaterMaterialState >> albedo [
	^ albedo
]

{ #category : #accessing }
WDCWaterMaterialState >> albedo: anObject [
	albedo := anObject
]

{ #category : #accessing }
WDCWaterMaterialState >> fresnel [
	^ fresnel
]

{ #category : #accessing }
WDCWaterMaterialState >> fresnel: anObject [
	fresnel := anObject
]

{ #category : #accessing }
WDCWaterMaterialState >> padding [
	^ padding
]

{ #category : #accessing }
WDCWaterMaterialState >> padding: anObject [
	padding := anObject
]

{ #category : #accessing }
WDCWaterMaterialState >> propagationSpeed [
	^ propagationSpeed
]

{ #category : #accessing }
WDCWaterMaterialState >> propagationSpeed: anObject [
	propagationSpeed := anObject
]

{ #category : #accessing }
WDCWaterMaterialState >> smoothness [
	^ smoothness
]

{ #category : #accessing }
WDCWaterMaterialState >> smoothness: anObject [
	smoothness := anObject
]

{ #category : #accessing }
WDCWaterMaterialState >> textureOffset [
	^ textureOffset
]

{ #category : #accessing }
WDCWaterMaterialState >> textureOffset: anObject [
	textureOffset := anObject
]

{ #category : #accessing }
WDCWaterMaterialState >> textureScale [
	^ textureScale
]

{ #category : #accessing }
WDCWaterMaterialState >> textureScale: anObject [
	textureScale := anObject
]
