Class {
	#name : #WDCSkinnedModelRotationAnimationChannel,
	#superclass : #WDCSkinnedModelAnimationChannel,
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #'as yet unclassified' }
WDCSkinnedModelRotationAnimationChannel >> applyInterpolatedState: interpolatedState toBoneState: bonePoseState [
	bonePoseState rotation: (QuaternionF32 xyzw: interpolatedState)
]
