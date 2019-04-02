"
I am a node  that poses a sub-local coordinate system that is associated with a per-instance matrix in the GPU.
"
Class {
	#name : #WDSGLocalSpatialInstanceObject,
	#superclass : #WDSGAbstractLocalSpatialObject,
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #changing }
WDSGLocalSpatialInstanceObject >> stateChanged [
	super stateChanged.
	parent ifNotNil: [ parent addPendingUpdate: self ]
]

{ #category : #accessing }
WDSGLocalSpatialInstanceObject >> updateRenderTransform [
	renderTransform := transform.
]

{ #category : #'as yet unclassified' }
WDSGLocalSpatialInstanceObject >> writeGPUStateInto: pointer at: offset [
	self updateRenderTransform.
	objectState transform: renderTransform.
	objectState storeBytesIn: pointer position: offset + 1.
]
