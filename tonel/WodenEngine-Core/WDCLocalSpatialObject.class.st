Class {
	#name : #WDCLocalSpatialObject,
	#superclass : #WDCAbstractSpatialObject,
	#instVars : [
		'owner'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-SpatialObject'
}

{ #category : #updating }
WDCLocalSpatialObject >> changed [
	owner ifNotNil: [ owner childChanged: self ]
]

{ #category : #accessing }
WDCLocalSpatialObject >> owner [
	^ owner
]

{ #category : #accessing }
WDCLocalSpatialObject >> owner: anObject [
	owner := anObject
]

{ #category : #writing }
WDCLocalSpatialObject >> writeGPUStateInto: pointer at: offset [
	state storeBytesIn: pointer position: offset + 1.
]
