Class {
	#name : #WDSGAbstractLocalSpatialObject,
	#superclass : #WDSGAbstractSpatialObject,
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #initialization }
WDSGAbstractLocalSpatialObject >> createSpatialObjectState [
	objectState := WDCLocalSpatialObject new
]

{ #category : #testing }
WDSGAbstractLocalSpatialObject >> isLocalSpatialNode [
	^ true
]
