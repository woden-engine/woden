Class {
	#name : #WDCStateTrackerDepthOnlyRenderMode,
	#superclass : #WDCStateTrackerRenderMode,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #'as yet unclassified' }
WDCStateTrackerDepthOnlyRenderMode >> activateMaterial: aMaterial on: aStateTracker [
	^ aMaterial activateDepthOnlyOn: aStateTracker
]
