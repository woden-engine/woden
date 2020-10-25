Class {
	#name : #WDCAnimationStepInterpolationMethod,
	#superclass : #WDCAnimationInterpolationMethod,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #'as yet unclassified' }
WDCAnimationStepInterpolationMethod >> interpolateFrame: keyFrame times: inputSamples at: frameTime withValues: outputSamples [
	^ outputSamples at: keyFrame
]
