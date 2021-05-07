Class {
	#name : #RWVRTrackerAttachment,
	#superclass : #RWObject,
	#instVars : [
		'trackerIndex',
		'attachmentPointTransform',
		'attachmentPointInverseTransform',
		'touch3DCursorVolume',
		'uiDisplayShape'
	],
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #'element manipulation' }
RWVRTrackerAttachment >> applyTransform: newTransform to: node inView: view [
	| newNodeTransform |
	newNodeTransform := newTransform transformTransform: self attachmentPointInverseTransform.
	node transform: newNodeTransform.
	touch3DCursorVolume ifNotNil: [
		view moveTouch3DCursorSphereVolume: touch3DCursorVolume for: self to: newNodeTransform
	].
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

{ #category : #'as yet unclassified' }
RWVRTrackerAttachment >> displayUIWith: aBlock [
	uiDisplayShape ifNotNil: [ 
		uiDisplayShape drawWith: aBlock
	]
]

{ #category : #initialization }
RWVRTrackerAttachment >> initializeElement: element [
	element trackerAttachment: self
]

{ #category : #accessing }
RWVRTrackerAttachment >> touch3DCursorVolume [

	^ touch3DCursorVolume
]

{ #category : #accessing }
RWVRTrackerAttachment >> touch3DCursorVolume: anObject [

	touch3DCursorVolume := anObject
]

{ #category : #accessing }
RWVRTrackerAttachment >> trackerIndex [
	^ trackerIndex ifNil: [ trackerIndex := 1 ]
]

{ #category : #accessing }
RWVRTrackerAttachment >> trackerIndex: anObject [

	trackerIndex := anObject
]

{ #category : #accessing }
RWVRTrackerAttachment >> uiDisplayShape [

	^ uiDisplayShape
]

{ #category : #accessing }
RWVRTrackerAttachment >> uiDisplayShape: anObject [

	uiDisplayShape := anObject
]
