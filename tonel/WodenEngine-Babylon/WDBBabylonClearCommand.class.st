Class {
	#name : #WDBBabylonClearCommand,
	#superclass : #WDBBabylonCommand,
	#instVars : [
		'color'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Babylon'
}

{ #category : #accessing }
WDBBabylonClearCommand >> color [
	^ color
]

{ #category : #accessing }
WDBBabylonClearCommand >> color: anObject [
	color := anObject
]

{ #category : #'as yet unclassified' }
WDBBabylonClearCommand >> executeWith: stateTracker on: surface [
	surface beginRenderPassWithColor: color
]
