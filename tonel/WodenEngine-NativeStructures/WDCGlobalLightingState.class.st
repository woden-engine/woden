Class {
	#name : #WDCGlobalLightingState,
	#superclass : #SysmelStructureType,
	#instVars : [
		'#groundLighting => Float32x4',
		'#skyLighting => Float32x4',
		'#shadowMapExtent => Float32x2',
		'#shadowMapInverseExtent => Float32x2',
		'#sunDirection => Float32x3',
		'#numberOfLights => Int32',
		'#lightSources => (WDCLightSourceData array: 16)'
	],
	#category : #'WodenEngine-NativeStructures-Core-Rendering'
}

{ #category : #accessing }
WDCGlobalLightingState >> groundLighting [
	^ groundLighting
]

{ #category : #accessing }
WDCGlobalLightingState >> groundLighting: anObject [
	groundLighting := anObject
]

{ #category : #accessing }
WDCGlobalLightingState >> lightSources [
	^ lightSources
]

{ #category : #accessing }
WDCGlobalLightingState >> lightSources: anObject [
	lightSources := anObject
]

{ #category : #accessing }
WDCGlobalLightingState >> numberOfLights [
	^ numberOfLights
]

{ #category : #accessing }
WDCGlobalLightingState >> numberOfLights: anObject [
	numberOfLights := anObject
]

{ #category : #accessing }
WDCGlobalLightingState >> shadowMapExtent [
	^ shadowMapExtent
]

{ #category : #accessing }
WDCGlobalLightingState >> shadowMapExtent: anObject [
	shadowMapExtent := anObject
]

{ #category : #accessing }
WDCGlobalLightingState >> shadowMapInverseExtent [
	^ shadowMapInverseExtent
]

{ #category : #accessing }
WDCGlobalLightingState >> shadowMapInverseExtent: anObject [
	shadowMapInverseExtent := anObject
]

{ #category : #accessing }
WDCGlobalLightingState >> skyLighting [
	^ skyLighting
]

{ #category : #accessing }
WDCGlobalLightingState >> skyLighting: anObject [
	skyLighting := anObject
]

{ #category : #accessing }
WDCGlobalLightingState >> sunDirection [
	^ sunDirection
]

{ #category : #accessing }
WDCGlobalLightingState >> sunDirection: anObject [
	sunDirection := anObject
]
