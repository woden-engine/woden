"
I represent a node with a spatial transform. I can be used to represent a single instance or a group of instances.
"
Class {
	#name : #WTSAbstractSpatialObject,
	#superclass : #WTSNode,
	#instVars : [
		'objectState',
		'renderPriority'
	],
	#category : 'WodenEngine-Scene-Graph'
}

{ #category : #accessing }
WTSAbstractSpatialObject >> color [
	^ objectState color
]

{ #category : #accessing }
WTSAbstractSpatialObject >> color: aColor [
	objectState color: aColor asWMVector4F.
	self stateChanged.
]

{ #category : #initialization }
WTSAbstractSpatialObject >> initialize [
	super initialize.
	renderPriority := RenderPriorityDefault.
	objectState := WTGenericObjectState new.
	objectState
		visible: 1;
		color: Color white asWMVector4F.
	
]

{ #category : #accessing }
WTSAbstractSpatialObject >> objectState [
	^ objectState
]

{ #category : #accessing }
WTSAbstractSpatialObject >> renderPriority [
	^ renderPriority
]

{ #category : #accessing }
WTSAbstractSpatialObject >> renderPriority: aPriority [
	renderPriority := aPriority
]

{ #category : #'some render priorities' }
WTSAbstractSpatialObject >> translucentRenderPriority [
	self renderPriority: RenderPriorityTranslucent
]

{ #category : #'some render priorities' }
WTSAbstractSpatialObject >> translucentSortedRenderPriority [
	self renderPriority: RenderPriorityTranslucentSorted
]

{ #category : #'as yet unclassified' }
WTSAbstractSpatialObject >> visible: aBoolean [
	super visible: aBoolean.
	objectState visible: aBoolean asBit.
	self stateChanged.
]
