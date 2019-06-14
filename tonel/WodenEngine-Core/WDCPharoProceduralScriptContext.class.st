Class {
	#name : #WDCPharoProceduralScriptContext,
	#superclass : #Object,
	#instVars : [
		'textureGenerator'
	],
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #accessing }
WDCPharoProceduralScriptContext >> at: param [
	^ textureGenerator at: param
]

{ #category : #accessing }
WDCPharoProceduralScriptContext >> textureGenerator [
	^ textureGenerator
]

{ #category : #accessing }
WDCPharoProceduralScriptContext >> textureGenerator: anObject [
	textureGenerator := anObject
]
