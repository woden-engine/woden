Class {
	#name : #WDCCompositeRenderable,
	#superclass : #WDCMutableRenderable,
	#instVars : [
		'renderables'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'extra per object rendering data' }
WDCCompositeRenderable >> createSceneDependentDataFor: engine into: bindings [
]

{ #category : #'as yet unclassified' }
WDCCompositeRenderable >> engine: newEngine [
	renderables do: [ :renderable |
		renderable engine: newEngine
	]
]

{ #category : #copying }
WDCCompositeRenderable >> postCopy [
	super postCopy.
	renderables := renderables collect: #copyForResourceCacheInstancing
]

{ #category : #rendering }
WDCCompositeRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [
	renderables do: [ :renderable |
		renderable renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex
	]
]

{ #category : #accessing }
WDCCompositeRenderable >> renderables [
	^ renderables
]

{ #category : #accessing }
WDCCompositeRenderable >> renderables: anObject [
	renderables := anObject
]
