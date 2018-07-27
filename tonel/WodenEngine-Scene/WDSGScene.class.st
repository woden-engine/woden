"
I represent a scene in the Woden 2 scene graph.
"
Class {
	#name : #WDSGScene,
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
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #'instance creation' }
WDSGScene class >> for: anEngine [
	^ self new initializeWithEngine: anEngine
]

{ #category : #adding }
WDSGScene >> add: aNode [
	roots add: aNode.
	aNode addedToScene: self
]

{ #category : #accessing }
WDSGScene >> backgroundColor [
	^ backgroundColor
]

{ #category : #accessing }
WDSGScene >> backgroundColor: anObject [
	backgroundColor := anObject
]

{ #category : #accessing }
WDSGScene >> engine [
	^ engine
]

{ #category : #accessing }
WDSGScene >> genericObjectStatePool [
	genericObjectStatePool ifNil: [
		genericObjectStatePool := WDCStreamingUniformBufferPool new
			elementType: WTGenericObjectState;
			engine: engine;
			yourself ].
	^ genericObjectStatePool
]

{ #category : #initialization }
WDSGScene >> initialize [
	super initialize.
	backgroundColor := Color black.
	roots := OrderedCollection new.
]

{ #category : #accessing }
WDSGScene >> initializeWithEngine: anEngine [
	self initializeWithEngine: anEngine shaderSignatureClass: WDCForwardRenderingShaderSignature
]

{ #category : #accessing }
WDSGScene >> initializeWithEngine: anEngine shaderSignatureClass: shaderSignatureClass [
	engine := anEngine.
	shaderSignature := shaderSignatureClass for: anEngine
]

{ #category : #accessing }
WDSGScene >> neutralGenericObjectInstanceState [
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
WDSGScene >> numberOfRoots [
	^ roots size
]

{ #category : #adding }
WDSGScene >> remove: aNode [
	roots remove: aNode.
	aNode removedFromScene: self
]

{ #category : #accessing }
WDSGScene >> roots [
	^ roots
]

{ #category : #accessing }
WDSGScene >> shaderSignature [
	^ shaderSignature
]
