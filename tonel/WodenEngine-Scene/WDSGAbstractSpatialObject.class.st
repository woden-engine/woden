"
I represent a node with a spatial transform. I can be used to represent a single instance or a group of instances.
"
Class {
	#name : #WDSGAbstractSpatialObject,
	#superclass : #WDSGNode,
	#instVars : [
		'objectState'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #adding }
WDSGAbstractSpatialObject >> addedToScene: aScene [
	super addedToScene: aScene.
	aScene addNodeWithPendingState: self.
]

{ #category : #'rendering phases' }
WDSGAbstractSpatialObject >> bakeLazyObjectStates [
	objectState transform: self globalTransform
]

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
WDSGAbstractSpatialObject >> createSpatialObjectState [
	self subclassResponsibility
]

{ #category : #caching }
WDSGAbstractSpatialObject >> globalTransformValidated [
	objectState transform: globalTransform
]

{ #category : #initialization }
WDSGAbstractSpatialObject >> initialize [
	super initialize.
	self createSpatialObjectState
]

{ #category : #accessing }
WDSGAbstractSpatialObject >> isOpaqueShadowCaster [
	^ objectState isOpaqueShadowCaster
]

{ #category : #accessing }
WDSGAbstractSpatialObject >> isOpaqueShadowCaster: aBoolean [
	objectState isOpaqueShadowCaster: aBoolean
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
WDSGAbstractSpatialObject >> renderable: ignored [
]

{ #category : #changing }
WDSGAbstractSpatialObject >> stateChanged [
	super stateChanged.
	objectState changed.
	scene ifNotNil: [ scene addNodeWithPendingState: self ].
]

{ #category : #'as yet unclassified' }
WDSGAbstractSpatialObject >> visible: aBoolean [
	super visible: aBoolean.
	objectState visible: aBoolean.
	self stateChanged.
]
