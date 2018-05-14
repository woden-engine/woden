Class {
	#name : #WDCStateTrackerPompeiiRenderMode,
	#superclass : #WDCStateTrackerRenderMode,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #'as yet unclassified' }
WDCStateTrackerPompeiiRenderMode >> activateMaterial: aMaterial on: aStateTracker [
	^ aMaterial activatePompeiiOn: aStateTracker
]
