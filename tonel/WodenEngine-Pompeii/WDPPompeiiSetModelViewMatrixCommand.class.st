Class {
	#name : #WDPPompeiiSetModelViewMatrixCommand,
	#superclass : #WDPPompeiiCommand,
	#instVars : [
		'matrix'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Pompeii'
}

{ #category : #'as yet unclassified' }
WDPPompeiiSetModelViewMatrixCommand >> executeWith: stateTracker on: surface [
	surface modelViewMatrixIndex: matrix
	
]

{ #category : #accessing }
WDPPompeiiSetModelViewMatrixCommand >> matrix [
	^ matrix
]

{ #category : #accessing }
WDPPompeiiSetModelViewMatrixCommand >> matrix: anObject [
	matrix := anObject
]
