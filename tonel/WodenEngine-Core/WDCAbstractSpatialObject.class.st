Class {
	#name : #WDCAbstractSpatialObject,
	#superclass : #Object,
	#instVars : [
		'engine',
		'state'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-SpatialObject'
}

{ #category : #accessing }
WDCAbstractSpatialObject >> createEngineDependantData [
]

{ #category : #accessing }
WDCAbstractSpatialObject >> destroyEngineDependantData [
]

{ #category : #accessing }
WDCAbstractSpatialObject >> engine [
	^ engine
]

{ #category : #accessing }
WDCAbstractSpatialObject >> engine: newEngine [
	engine == newEngine ifTrue: [ ^ self ].
	engine ifNotNil: [ self destroyEngineDependantData ].
	engine := newEngine.
	engine ifNotNil: [ self createEngineDependantData ].

]

{ #category : #initialization }
WDCAbstractSpatialObject >> initialize [
	super initialize.
	state := WTGenericObjectState new.
	state
		visible: 1;
		color: Color white asWMVector4F.
]

{ #category : #rendering }
WDCAbstractSpatialObject >> renderRenderable: renderable with: stateTracker [
]

{ #category : #accessing }
WDCAbstractSpatialObject >> state [
	^ state
]

{ #category : #accessing }
WDCAbstractSpatialObject >> state: anObject [
	state := anObject
]

{ #category : #transforming }
WDCAbstractSpatialObject >> transform [
	^ state transform
]

{ #category : #transforming }
WDCAbstractSpatialObject >> transform: aTransform [
	state transform: aTransform
]

{ #category : #'as yet unclassified' }
WDCAbstractSpatialObject >> updateCommonGpuStateForFrame: frameBufferingIndex [
]
