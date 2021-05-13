"
I am a node  that poses a sub-local coordinate system that is associated with a per-instance matrix in the GPU.
"
Class {
	#name : #WDSGLocalSpatialInstanceObject,
	#superclass : #WDSGAbstractLocalSpatialObject,
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #'rendering phases' }
WDSGLocalSpatialInstanceObject >> bakeLazyObjectStates [
	objectState 
		transform: self instanceTransform;
		visible: self visible
]

{ #category : #'as yet unclassified' }
WDSGLocalSpatialInstanceObject >> exportNodeElementsWith: exporter [
	super exportNodeElementsWith: exporter.
	exporter
		transform: self instanceTransform;
		renderable: parent renderable
	
]

{ #category : #caching }
WDSGLocalSpatialInstanceObject >> globalIsVisibleValidated [
]

{ #category : #caching }
WDSGLocalSpatialInstanceObject >> globalTransformValidated [
]

{ #category : #'as yet unclassified' }
WDSGLocalSpatialInstanceObject >> instanceTransform [
	^ transform
]

{ #category : #'rendering phases' }
WDSGLocalSpatialInstanceObject >> transformChanged [
	super transformChanged.
	objectState transform: self instanceTransform
]
