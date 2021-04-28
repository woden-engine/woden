Class {
	#name : #RWTouch3DCursorEvent,
	#superclass : #RWEvent,
	#instVars : [
		'device',
		'volume',
		'cursorTransform'
	],
	#category : #'WodenEngine-Roassal-Events'
}

{ #category : #accessing }
RWTouch3DCursorEvent >> cursorTransform [

	^ cursorTransform
]

{ #category : #accessing }
RWTouch3DCursorEvent >> cursorTransform: anObject [

	cursorTransform := anObject
]

{ #category : #accessing }
RWTouch3DCursorEvent >> device [

	^ device
]

{ #category : #accessing }
RWTouch3DCursorEvent >> device: anObject [

	device := anObject
]

{ #category : #accessing }
RWTouch3DCursorEvent >> volume [

	^ volume
]

{ #category : #accessing }
RWTouch3DCursorEvent >> volume: anObject [

	volume := anObject
]
