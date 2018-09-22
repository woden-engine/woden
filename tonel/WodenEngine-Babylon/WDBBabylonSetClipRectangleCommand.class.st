Class {
	#name : #WDBBabylonSetClipRectangleCommand,
	#superclass : #WDBBabylonCommand,
	#instVars : [
		'rectangle'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Babylon'
}

{ #category : #'as yet unclassified' }
WDBBabylonSetClipRectangleCommand >> executeWith: stateTracker on: surface [
	stateTracker scissorRectangle: rectangle
]

{ #category : #accessing }
WDBBabylonSetClipRectangleCommand >> rectangle [
	^ rectangle
]

{ #category : #accessing }
WDBBabylonSetClipRectangleCommand >> rectangle: anObject [
	rectangle := anObject
]
