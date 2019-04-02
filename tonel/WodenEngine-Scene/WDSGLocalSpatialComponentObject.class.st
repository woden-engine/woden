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
