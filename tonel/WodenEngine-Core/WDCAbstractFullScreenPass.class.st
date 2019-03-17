Class {
	#name : #WDCAbstractFullScreenPass,
	#superclass : #Object,
	#instVars : [
		'engine'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #'instance creation' }
WDCAbstractFullScreenPass class >> for: anEngine [
	^ self new engine: anEngine
]

{ #category : #'as yet unclassified' }
WDCAbstractFullScreenPass >> applyWithStateTracker: stateTracker [
]

{ #category : #accessing }
WDCAbstractFullScreenPass >> engine [
	^ engine
]

{ #category : #accessing }
WDCAbstractFullScreenPass >> engine: anObject [
	engine := anObject
]

{ #category : #shaders }
WDCAbstractFullScreenPass >> vertexShader [
	^ engine resourceCache screenQuadVertexShader
]
