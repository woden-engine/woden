"
I represent a node with a spatial transform. I can be used to represent a single instance or a group of instances.
"
Class {
	#name : #WDSGAbstractSpatialObject,
	#superclass : #WDSGNode,
	#instVars : [
		'isOpaqueShadowCaster',
		'objectState',
		'renderPriority'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #accessing }
WDSGAbstractSpatialObject >> color [
	^ objectState color
]

{ #category : #accessing }
WDSGAbstractSpatialObject >> color: aColor [
	objectState color: aColor asWMVector4F.
	self stateChanged.
]

{ #category : #initialization }
WDSGAbstractSpatialObject >> initialize [
	super initialize.
	renderPriority := RenderPriorityDefault.
	isOpaqueShadowCaster := true.
	objectState := WTGenericObjectState new.
	objectState
		visible: 1;
		color: Color white asWMVector4F.
	
]

{ #category : #accessing }
WDSGAbstractSpatialObject >> isOpaqueShadowCaster [
	^ isOpaqueShadowCaster
]

{ #category : #accessing }
WDSGAbstractSpatialObject >> isOpaqueShadowCaster: anObject [
	isOpaqueShadowCaster := anObject
]

{ #category : #testing }
WDSGAbstractSpatialObject >> isSpatialObject [
	^ true
]

{ #category : #accessing }
WDSGAbstractSpatialObject >> objectState [
	^ objectState
]

{ #category : #accessing }
WDSGAbstractSpatialObject >> renderPriority [
	^ renderPriority
]

{ #category : #accessing }
WDSGAbstractSpatialObject >> renderPriority: aPriority [
	renderPriority := aPriority
]

{ #category : #'some render priorities' }
WDSGAbstractSpatialObject >> translucentRenderPriority [
	self renderPriority: RenderPriorityTranslucent
]

{ #category : #'some render priorities' }
WDSGAbstractSpatialObject >> translucentSortedRenderPriority [
	self renderPriority: RenderPriorityTranslucentSorted
]

{ #category : #'as yet unclassified' }
WDSGAbstractSpatialObject >> visible: aBoolean [
	super visible: aBoolean.
	objectState visible: aBoolean asBit.
	self stateChanged.
]
