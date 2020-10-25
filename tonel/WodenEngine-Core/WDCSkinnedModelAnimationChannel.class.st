Class {
	#name : #WDCSkinnedModelAnimationChannel,
	#superclass : #Object,
	#instVars : [
		'targetBoneIndex',
		'inputMinValue',
		'inputMaxValue',
		'inputSamples',
		'outputSamples',
		'interpolationMethod'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #'as yet unclassified' }
WDCSkinnedModelAnimationChannel >> applyInterpolatedState: interpolatedState toBoneState: bonePoseState [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCSkinnedModelAnimationChannel >> applyToBoneState: bonePoseState repeated: isRepeated inTime: animationTime [
	| interpolatedState |
	interpolatedState := self computeInterpolatedStateInTime: animationTime repeated: isRepeated.
	^ self applyInterpolatedState: interpolatedState toBoneState: bonePoseState
]

{ #category : #'as yet unclassified' }
WDCSkinnedModelAnimationChannel >> computeInterpolatedStateInTime: animationTime repeated: isRepeated [
	| frameTime keyFrame |
	outputSamples size = 1 ifTrue: [ ^ outputSamples first ].
	frameTime := isRepeated
		ifTrue: [ animationTime floorModule: inputMaxValue ]
		ifFalse:  [ animationTime ].

	frameTime <= inputMinValue ifTrue: [ ^ interpolationMethod getFirstConstantValueFrom: outputSamples ].
	frameTime >= inputMaxValue ifTrue: [ ^ interpolationMethod getLastConstantValueFrom: outputSamples ].
	keyFrame := self findKeyFrameForTime: frameTime.
	^ interpolationMethod interpolateFrame: keyFrame times: inputSamples at: frameTime withValues: outputSamples
]

{ #category : #'as yet unclassified' }
WDCSkinnedModelAnimationChannel >> findKeyFrameForTime: time [
	| bestFound |
	self flag: 'FIXME: use a binary search here'.
	bestFound := nil.
	inputSamples doWithIndex: [ :each :index |
		each <= time ifTrue: [
			bestFound := index
		]
	].
	self assert: bestFound isNotNil.
	^ bestFound
]

{ #category : #accessing }
WDCSkinnedModelAnimationChannel >> inputMaxValue [
	^ inputMaxValue
]

{ #category : #accessing }
WDCSkinnedModelAnimationChannel >> inputMaxValue: anObject [
	inputMaxValue := anObject
]

{ #category : #accessing }
WDCSkinnedModelAnimationChannel >> inputMinValue [
	^ inputMinValue
]

{ #category : #accessing }
WDCSkinnedModelAnimationChannel >> inputMinValue: anObject [
	inputMinValue := anObject
]

{ #category : #accessing }
WDCSkinnedModelAnimationChannel >> inputSamples [
	^ inputSamples
]

{ #category : #accessing }
WDCSkinnedModelAnimationChannel >> inputSamples: anObject [
	inputSamples := anObject
]

{ #category : #accessing }
WDCSkinnedModelAnimationChannel >> interpolationMethod [
	^ interpolationMethod
]

{ #category : #accessing }
WDCSkinnedModelAnimationChannel >> interpolationMethod: anObject [
	interpolationMethod := anObject
]

{ #category : #accessing }
WDCSkinnedModelAnimationChannel >> outputSamples [
	^ outputSamples
]

{ #category : #accessing }
WDCSkinnedModelAnimationChannel >> outputSamples: anObject [
	outputSamples := anObject
]

{ #category : #accessing }
WDCSkinnedModelAnimationChannel >> targetBoneIndex [
	^ targetBoneIndex
]

{ #category : #accessing }
WDCSkinnedModelAnimationChannel >> targetBoneIndex: anObject [
	targetBoneIndex := anObject
]
