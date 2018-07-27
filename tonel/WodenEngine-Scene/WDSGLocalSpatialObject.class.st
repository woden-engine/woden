"
I am a node  that poses a sub-local coordinate system that is associated with a per-instance matrix in the GPU.
"
Class {
	#name : #WDSGLocalSpatialObject,
	#superclass : #WDSGAbstractSpatialObject,
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #testing }
WDSGLocalSpatialObject >> isInstance [
	^ true
]

{ #category : #changing }
WDSGLocalSpatialObject >> stateChanged [
	super stateChanged.
	parent ifNotNil: [ parent addPendingUpdate: self ]
]

{ #category : #accessing }
WDSGLocalSpatialObject >> updateRenderTransform [
	renderTransform := transform.
]

{ #category : #'as yet unclassified' }
WDSGLocalSpatialObject >> writeGPUStateInto: pointer at: offset [
	self updateRenderTransform.
	objectState transform: renderTransform.
	objectState storeBytesIn: pointer position: offset + 1.
]
