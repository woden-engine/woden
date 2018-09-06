Class {
	#name : #WDPPompeiiSetClipRectangleCommand,
	#superclass : #WDPPompeiiCommand,
	#instVars : [
		'rectangle'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Pompeii'
}

{ #category : #'as yet unclassified' }
WDPPompeiiSetClipRectangleCommand >> executeWith: stateTracker on: surface [
	stateTracker scissorRectangle: rectangle
]

{ #category : #accessing }
WDPPompeiiSetClipRectangleCommand >> rectangle [
	^ rectangle
]

{ #category : #accessing }
WDPPompeiiSetClipRectangleCommand >> rectangle: anObject [
	rectangle := anObject
]
