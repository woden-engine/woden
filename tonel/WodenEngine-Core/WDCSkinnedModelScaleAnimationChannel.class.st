Class {
	#name : #WDCSkinnedModelScaleAnimationChannel,
	#superclass : #WDCSkinnedModelAnimationChannel,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #'as yet unclassified' }
WDCSkinnedModelScaleAnimationChannel >> applyInterpolatedState: interpolatedState toBoneState: bonePoseState [
	bonePoseState scale: interpolatedState
]
