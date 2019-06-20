Class {
	#name : #WDCEnvironmentLightingProbe,
	#superclass : #Object,
	#instVars : [
		'diffuseIrradianceMap',
		'specularIrradianceMap'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #accessing }
WDCEnvironmentLightingProbe >> diffuseIrradianceMap [
	^ diffuseIrradianceMap
]

{ #category : #accessing }
WDCEnvironmentLightingProbe >> diffuseIrradianceMap: anObject [
	diffuseIrradianceMap := anObject
]

{ #category : #accessing }
WDCEnvironmentLightingProbe >> specularIrradianceMap [
	^ specularIrradianceMap
]

{ #category : #accessing }
WDCEnvironmentLightingProbe >> specularIrradianceMap: anObject [
	specularIrradianceMap := anObject
]
