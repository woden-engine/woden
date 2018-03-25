Class {
	#name : #WDCStateTrackerRenderMode,
	#superclass : #Object,
	#pools : [
		'AGPUConstants'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : 'WodenEngine-Core-Rendering'
}

{ #category : #accessing }
WDCStateTrackerRenderMode class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'as yet unclassified' }
WDCStateTrackerRenderMode >> activateMaterial: aMaterial on: aStateTracker [
	self subclassResponsibility
]
