"
I represent a scene in the Woden 2 scene graph.
"
Class {
	#name : #WTSScene,
	#superclass : #Object,
	#instVars : [
		'engine',
		'backgroundColor',
		'roots',
		'shaderSignature',
		'genericObjectStatePool',
		'neutralObjectInstanceStatePool',
		'neutralObjectInstanceState'
	],
	#category : 'WodenEngine-Scene-Graph'
}

{ #category : #'instance creation' }
WTSScene class >> for: anEngine [
	^ self new initializeWithEngine: anEngine
]

{ #category : #adding }
WTSScene >> add: aNode [
	roots add: aNode.
	aNode addedToScene: self
]

{ #category : #accessing }
WTSScene >> backgroundColor [
	^ backgroundColor
]

{ #category : #accessing }
WTSScene >> backgroundColor: anObject [
	backgroundColor := anObject
]

{ #category : #accessing }
WTSScene >> engine [
	^ engine
]

{ #category : #accessing }
WTSScene >> genericObjectStatePool [
	genericObjectStatePool ifNil: [
		genericObjectStatePool := WDCStreamingUniformBufferPool new
			elementType: WTGenericObjectState;
			engine: engine;
			yourself ].
	^ genericObjectStatePool
]

{ #category : #initialization }
WTSScene >> initialize [
	super initialize.
	backgroundColor := Color black.
	roots := OrderedCollection new.
]

{ #category : #accessing }
WTSScene >> initializeWithEngine: anEngine [
	self initializeWithEngine: anEngine shaderSignatureClass: WDCForwardRenderingShaderSignature
]

{ #category : #accessing }
WTSScene >> initializeWithEngine: anEngine shaderSignatureClass: shaderSignatureClass [
	engine := anEngine.
	shaderSignature := shaderSignatureClass for: anEngine
]

{ #category : #accessing }
WTSScene >> neutralGenericObjectInstanceState [
	neutralObjectInstanceStatePool ifNil: [
		neutralObjectInstanceStatePool := WDCStreamingStorageBufferPool new
			heapSize: 1;
			elementType: WTGenericObjectState;
			engine: engine;
			yourself.
			
		neutralObjectInstanceState := neutralObjectInstanceStatePool allocate.
		neutralObjectInstanceState value: WTGenericObjectState neutralState
	].
	^ neutralObjectInstanceState
]

{ #category : #accessing }
WTSScene >> numberOfRoots [
	^ roots size
]

{ #category : #adding }
WTSScene >> remove: aNode [
	roots remove: aNode.
	aNode removedFromScene: self
]

{ #category : #accessing }
WTSScene >> roots [
	^ roots
]

{ #category : #accessing }
WTSScene >> shaderSignature [
	^ shaderSignature
]
