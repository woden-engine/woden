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
	objectState
		transform: self globalTransform;
		visible: self globalIsVisible.
]

{ #category : #accessing }
WDSGAbstractSpatialObject >> color [
	^ objectState color
]

{ #category : #accessing }
WDSGAbstractSpatialObject >> color: aColor [
	objectState color: aColor asFloat32x4.
	self stateChanged.
]

{ #category : #initialization }
WDSGAbstractSpatialObject >> createSpatialObjectState [
	self subclassResponsibility
]

{ #category : #caching }
WDSGAbstractSpatialObject >> globalIsVisibleValidated [
	objectState visible: globalIsVisible
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

{ #category : #testing }
WDSGAbstractSpatialObject >> isSpatialObject [
	^ true
]

{ #category : #accessing }
WDSGAbstractSpatialObject >> objectState [
	^ objectState
]

{ #category : #copying }
WDSGAbstractSpatialObject >> postCopy [
	objectState := objectState copy.
	super postCopy.
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
