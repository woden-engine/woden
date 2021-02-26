Class {
	#name : #RWVRGenericTrackedDevice,
	#superclass : #RWVRTrackedDevice,
	#instVars : [
		'view',
		'index'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #adding }
RWVRGenericTrackedDevice >> addToView: aView [
	view := aView.
	aView addGenericTrackedDevice: self
]

{ #category : #accessing }
RWVRGenericTrackedDevice >> index [

	^ index
]

{ #category : #accessing }
RWVRGenericTrackedDevice >> index: anObject [

	index := anObject
]

{ #category : #accessing }
RWVRGenericTrackedDevice >> transform: newTransform [
	super transform: newTransform.
	view applyGenericTrackedDevice: self transform: newTransform
]
