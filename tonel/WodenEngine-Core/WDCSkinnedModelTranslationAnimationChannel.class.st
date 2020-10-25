Class {
	#name : #WDCSkinnedModelTranslationAnimationChannel,
	#superclass : #WDCSkinnedModelAnimationChannel,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #'as yet unclassified' }
WDCSkinnedModelTranslationAnimationChannel >> applyInterpolatedState: interpolatedState toBoneState: bonePoseState [
	bonePoseState translation: interpolatedState
]
