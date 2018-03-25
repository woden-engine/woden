"
I am a node  that poses a sub-local coordinate system that is associated with a per-instance matrix in the GPU.
"
Class {
	#name : #WTSLocalSpatialObject,
	#superclass : #WTSAbstractSpatialObject,
	#category : 'WodenEngine-Scene-Graph'
}

{ #category : #testing }
WTSLocalSpatialObject >> isInstance [
	^ true
]

{ #category : #changing }
WTSLocalSpatialObject >> stateChanged [
	super stateChanged.
	parent ifNotNil: [ parent addPendingUpdate: self ]
]

{ #category : #accessing }
WTSLocalSpatialObject >> updateRenderTransform [
	renderTransform := transform.
]

{ #category : #'as yet unclassified' }
WTSLocalSpatialObject >> writeGPUStateInto: pointer at: offset [
	self updateRenderTransform.
	objectState transform: renderTransform.
	objectState storeBytesIn: pointer position: offset + 1.
]
