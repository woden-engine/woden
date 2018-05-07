Class {
	#name : #WDPPompeiiSetModelViewMatricesCommand,
	#superclass : #WDPPompeiiCommand,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Pompeii'
}

{ #category : #'as yet unclassified' }
WDPPompeiiSetModelViewMatricesCommand >> executeWith: stateTracker on: surface [
	self flag: 'TODO: Use push constants for this'
	
]
