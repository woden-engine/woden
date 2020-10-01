Class {
	#name : #WDCSpecularityGlossinessMaterialState,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#emission => Float32x4',
		'#albedo => Float32x4',
		'#specularFactor => CompactFloat32x3',
		'#glossinessFactor => Float32',
		'#alphaCutoff => Float32'
	],
	#category : #'WodenEngine-NativeStructures-Core-Material'
}

{ #category : #accessing }
WDCSpecularityGlossinessMaterialState >> albedo [
	^ albedo
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterialState >> albedo: anObject [
	albedo := anObject
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterialState >> alphaCutoff [
	^ alphaCutoff
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterialState >> alphaCutoff: anObject [
	alphaCutoff := anObject
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterialState >> emission [
	^ emission
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterialState >> emission: anObject [
	emission := anObject
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterialState >> glossinessFactor [
	^ glossinessFactor
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterialState >> glossinessFactor: anObject [
	glossinessFactor := anObject
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterialState >> specularFactor [
	^ specularFactor
]

{ #category : #accessing }
WDCSpecularityGlossinessMaterialState >> specularFactor: anObject [
	specularFactor := anObject
]
