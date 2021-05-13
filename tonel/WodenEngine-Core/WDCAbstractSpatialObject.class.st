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
WDCAbstractSpatialObject >> color [
	^ state color
]

{ #category : #accessing }
WDCAbstractSpatialObject >> color: aColor [
	state color: aColor
]

{ #category : #'as yet unclassified' }
WDCAbstractSpatialObject >> computeBoundingBoxForRenderable: renderable [
	^ renderable boundingBox transformedWith: self transform
]

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
	state := WDCGenericObjectState new.
	state
		visible: 1;
		color: Color white asFloat32x4.
]

{ #category : #rendering }
WDCAbstractSpatialObject >> renderRenderable: renderable renderPassDependenciesWith: stateTracker [
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
WDCAbstractSpatialObject >> updateCommonGpuStateForFrame: frameIndex [
]

{ #category : #'as yet unclassified' }
WDCAbstractSpatialObject >> updateGpuStateForFrame: frameIndex camera: camera [
]

{ #category : #accessing }
WDCAbstractSpatialObject >> visible [
	^ state visible ~~ 0
]

{ #category : #accessing }
WDCAbstractSpatialObject >> visible: aBoolean [
	state visible: aBoolean asBit
]
