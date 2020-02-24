Class {
	#name : #RWVRTrackedDevice,
	#superclass : #WDCVREventHandler,
	#instVars : [
		'deviceHandle',
		'element',
		'shape'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #'instance creation' }
RWVRTrackedDevice class >> for: view device: aTrackedDevice [
	^ self new deviceHandle: aTrackedDevice; addToView: view; yourself
]

{ #category : #adding }
RWVRTrackedDevice >> addToView: aView [
	shape := RWCube new size: 0.1.
	element := shape elementOn: self.
	aView addInternalElement: element.
]

{ #category : #accessing }
RWVRTrackedDevice >> deviceHandle [
	^ deviceHandle
]

{ #category : #accessing }
RWVRTrackedDevice >> deviceHandle: anObject [
	deviceHandle := anObject.
	deviceHandle eventHandler: self.
]

{ #category : #accessing }
RWVRTrackedDevice >> element [
	^ element
]

{ #category : #accessing }
RWVRTrackedDevice >> element: anObject [
	element := anObject
]

{ #category : #accessing }
RWVRTrackedDevice >> transform: newTransform [
	element transform: newTransform.
	self transformChanged
]

{ #category : #accessing }
RWVRTrackedDevice >> transformChanged [
]
