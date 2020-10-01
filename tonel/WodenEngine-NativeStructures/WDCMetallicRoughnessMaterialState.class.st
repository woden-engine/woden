Class {
	#name : #WDCMetallicRoughnessMaterialState,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#emission => Float32x4',
		'#albedo => Float32x4',
		'#metallicFactor => Float32',
		'#roughnessFactor => Float32',
		'#alphaCutoff => Float32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Material'
}

{ #category : #accessing }
WDCMetallicRoughnessMaterialState >> albedo [
	^ albedo
]

{ #category : #accessing }
WDCMetallicRoughnessMaterialState >> albedo: anObject [
	albedo := anObject
]

{ #category : #accessing }
WDCMetallicRoughnessMaterialState >> alphaCutoff [
	^ alphaCutoff
]

{ #category : #accessing }
WDCMetallicRoughnessMaterialState >> alphaCutoff: anObject [
	alphaCutoff := anObject
]

{ #category : #accessing }
WDCMetallicRoughnessMaterialState >> emission [
	^ emission
]

{ #category : #accessing }
WDCMetallicRoughnessMaterialState >> emission: anObject [
	emission := anObject
]

{ #category : #accessing }
WDCMetallicRoughnessMaterialState >> metallicFactor [
	^ metallicFactor
]

{ #category : #accessing }
WDCMetallicRoughnessMaterialState >> metallicFactor: anObject [
	metallicFactor := anObject
]

{ #category : #accessing }
WDCMetallicRoughnessMaterialState >> roughnessFactor [
	^ roughnessFactor
]

{ #category : #accessing }
WDCMetallicRoughnessMaterialState >> roughnessFactor: anObject [
	roughnessFactor := anObject
]
