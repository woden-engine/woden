Class {
	#name : #WDCStateTrackerShadowRenderMode,
	#superclass : #WDCStateTrackerRenderMode,
	#pools : [
		'AGPUConstants'
	],
	#category : 'WodenEngine-Core-Rendering'
}

{ #category : #'as yet unclassified' }
WDCStateTrackerShadowRenderMode >> activateMaterial: aMaterial on: aStateTracker [
	^ aMaterial activateShadowOn: aStateTracker
]
