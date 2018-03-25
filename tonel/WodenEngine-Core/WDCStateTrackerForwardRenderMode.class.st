Class {
	#name : #WDCStateTrackerForwardRenderMode,
	#superclass : #WDCStateTrackerRenderMode,
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Core-Rendering'
}

{ #category : #'as yet unclassified' }
WDCStateTrackerForwardRenderMode >> activateMaterial: aMaterial on: aStateTracker [
	^ aMaterial activateForwardOn: aStateTracker
]
