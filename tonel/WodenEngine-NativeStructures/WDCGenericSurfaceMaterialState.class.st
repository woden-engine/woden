Class {
	#name : #WDCGenericSurfaceMaterialState,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#albedo => Float32x4',
		'#fresnel => Float32x3',
		'#smoothness => Float32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Material'
}

{ #category : #accessing }
WDCGenericSurfaceMaterialState >> albedo [
	^ albedo
]

{ #category : #accessing }
WDCGenericSurfaceMaterialState >> albedo: anObject [
	albedo := anObject
]

{ #category : #accessing }
WDCGenericSurfaceMaterialState >> fresnel [
	^ fresnel
]

{ #category : #accessing }
WDCGenericSurfaceMaterialState >> fresnel: anObject [
	fresnel := anObject
]

{ #category : #accessing }
WDCGenericSurfaceMaterialState >> smoothness [
	^ smoothness
]

{ #category : #accessing }
WDCGenericSurfaceMaterialState >> smoothness: anObject [
	smoothness := anObject
]
