Class {
	#name : #RWEvent,
	#superclass : #Announcement,
	#instVars : [
		'element'
	],
	#category : 'WodenEngine-Roassal-Events'
}

{ #category : #accessing }
RWEvent >> element [
	^ element
]

{ #category : #accessing }
RWEvent >> element: anObject [
	element := anObject
]

{ #category : #'as yet unclassified' }
RWEvent >> sendToElement [
	element announce: self
]

{ #category : #'as yet unclassified' }
RWEvent >> signalUpdate [
	"Compatibility"
	self element ifNotNil: [ self element changed ]
]
