Class {
	#name : #WDCAnimationInterpolationMethod,
	#superclass : #Object,
	#pools : [
		'AGPUConstants'
	],
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #'instance creation' }
WDCAnimationInterpolationMethod class >> cubicSpline [
	^ WDCAnimationCubicSplineInterpolationMethod uniqueInstance
]

{ #category : #'instance creation' }
WDCAnimationInterpolationMethod class >> linear [
	^ WDCAnimationLinearInterpolationMethod uniqueInstance
]

{ #category : #'instance creation' }
WDCAnimationInterpolationMethod class >> step [
	^ WDCAnimationStepInterpolationMethod uniqueInstance
]

{ #category : #accessing }
WDCAnimationInterpolationMethod class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]

{ #category : #'as yet unclassified' }
WDCAnimationInterpolationMethod >> getFirstConstantValueFrom: outputSamples [
	^ outputSamples first
]

{ #category : #'as yet unclassified' }
WDCAnimationInterpolationMethod >> getLastConstantValueFrom: outputSamples [
	^ outputSamples last
]

{ #category : #'as yet unclassified' }
WDCAnimationInterpolationMethod >> interpolateFrame: keyFrame times: inputSamples at: frameTime withValues: outputSamples [
	self subclassResponsibility
]
