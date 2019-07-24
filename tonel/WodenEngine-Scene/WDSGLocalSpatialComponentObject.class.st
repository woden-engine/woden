Class {
	#name : #WDSGLocalSpatialComponentObject,
	#superclass : #WDSGAbstractLocalSpatialObject,
	#instVars : [
		'meshComponent'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #drawing }
WDSGLocalSpatialComponentObject >> buildMeshOn: meshBuilder [
	self visible ifFalse: [ ^ self ].
	meshBuilder currentColor: self color.
	meshComponent buildMeshOn: meshBuilder
	
]

{ #category : #accessing }
WDSGLocalSpatialComponentObject >> meshComponent [
	^ meshComponent
]

{ #category : #accessing }
WDSGLocalSpatialComponentObject >> meshComponent: anObject [
	meshComponent := anObject
]

{ #category : #drawing }
WDSGLocalSpatialComponentObject >> postCopy [
	| oldMeshComponent |
	oldMeshComponent := meshComponent.
	meshComponent := nil.
	super postCopy.
	self meshComponent: oldMeshComponent copy
]
