Class {
	#name : #RWVRTrackerAttachment,
	#superclass : #RWObject,
	#instVars : [
		'trackerIndex',
		'attachmentPointTransform',
		'attachmentPointInverseTransform'
	],
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #'element manipulation' }
RWVRTrackerAttachment >> applyTransform: newTransform to: node [
	node transform: (newTransform transformTransform: self attachmentPointInverseTransform)
]

{ #category : #accessing }
RWVRTrackerAttachment >> attachmentPointInverseTransform [
	^ attachmentPointInverseTransform ifNil: [ attachmentPointInverseTransform := self attachmentPointTransform inverse ]
]

{ #category : #accessing }
RWVRTrackerAttachment >> attachmentPointTransform [
	^ attachmentPointTransform ifNil: [ attachmentPointTransform := ReversibleAffineTransform3dF32 identity ]
]

{ #category : #accessing }
RWVRTrackerAttachment >> attachmentPointTransform: anObject [
	attachmentPointTransform := anObject.
	attachmentPointInverseTransform := nil
]

{ #category : #initialization }
RWVRTrackerAttachment >> initializeElement: element [
	element trackerAttachment: self
]

{ #category : #accessing }
RWVRTrackerAttachment >> trackerIndex [
	^ trackerIndex ifNil: [ trackerIndex := 1 ]
]

{ #category : #accessing }
RWVRTrackerAttachment >> trackerIndex: anObject [

	trackerIndex := anObject
]
