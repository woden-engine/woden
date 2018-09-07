Class {
	#name : #WDCSmalltalkProceduralScriptContext,
	#superclass : #Object,
	#instVars : [
		'parameters'
	],
	#category : #'WodenEngine-Core-Texture'
}

{ #category : #accessing }
WDCSmalltalkProceduralScriptContext >> at: aParamName [
	parameters ifNil: [ ^ self ].
	^ self parameters at: aParamName ifAbsent: [ nil ]
]

{ #category : #accessing }
WDCSmalltalkProceduralScriptContext >> parameters [
	^ parameters
]

{ #category : #accessing }
WDCSmalltalkProceduralScriptContext >> parameters: anObject [
	parameters := anObject
]

{ #category : #printing }
WDCSmalltalkProceduralScriptContext >> printOn: aStream [
	super printOn: aStream.
	aStream print: parameters
]
