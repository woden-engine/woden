Class {
	#name : #WDCAnimationLinearInterpolationMethod,
	#superclass : #WDCAnimationInterpolationMethod,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #'as yet unclassified' }
WDCAnimationLinearInterpolationMethod >> interpolateFrame: keyFrame times: inputSamples at: frameTime withValues: outputSamples [
	| startTime endTime alpha |
	startTime := inputSamples at: keyFrame.
	endTime := inputSamples at: keyFrame + 1.
	alpha := (frameTime - startTime) / (endTime - startTime).
	^ (outputSamples at: keyFrame) interpolateTo: (outputSamples at: keyFrame + 1) at: alpha
]
