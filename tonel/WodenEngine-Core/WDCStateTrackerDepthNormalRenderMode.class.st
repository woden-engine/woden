Class {
	#name : #WDCStateTrackerDepthNormalRenderMode,
	#superclass : #WDCStateTrackerRenderMode,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #'as yet unclassified' }
WDCStateTrackerDepthNormalRenderMode >> activateMaterial: aMaterial on: aStateTracker [
	^ aMaterial activateDepthNormalOn: aStateTracker
]
