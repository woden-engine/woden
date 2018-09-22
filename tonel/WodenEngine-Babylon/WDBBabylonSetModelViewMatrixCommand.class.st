Class {
	#name : #WDBBabylonSetModelViewMatrixCommand,
	#superclass : #WDBBabylonCommand,
	#instVars : [
		'matrix'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Babylon'
}

{ #category : #'as yet unclassified' }
WDBBabylonSetModelViewMatrixCommand >> executeWith: stateTracker on: surface [
	surface modelViewMatrixIndex: matrix
	
]

{ #category : #accessing }
WDBBabylonSetModelViewMatrixCommand >> matrix [
	^ matrix
]

{ #category : #accessing }
WDBBabylonSetModelViewMatrixCommand >> matrix: anObject [
	matrix := anObject
]
