Class {
	#name : #WDIGLTF2AnimationChannel,
	#superclass : #Object,
	#instVars : [
		'sampler',
		'targetArmature',
		'targetBoneIndex',
		'targetProperty'
	],
	#classVars : [
		'TargetPropertyToClassMap'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #'class initialization' }
WDIGLTF2AnimationChannel class >> initialize [
	TargetPropertyToClassMap := Dictionary newFromPairs: { 
		#translation . WDCSkinnedModelTranslationAnimationChannel.
		#rotation . WDCSkinnedModelRotationAnimationChannel.
		#scale . WDCSkinnedModelScaleAnimationChannel.
		#weight . WDCSkinnedModelWeightsAnimationChannel.
	}.
]

{ #category : #converting }
WDIGLTF2AnimationChannel >> asSkinnedModelAnimationChannel [
	^ self skinnedModelAnimationChannelClass new
		targetArmature: targetArmature;
		targetBoneIndex: targetBoneIndex;
		inputSamples: sampler inputValues;
		inputMinValue: sampler inputMinValue;
		inputMaxValue: sampler inputMaxValue;
		outputSamples: sampler outputValues;
		interpolationMethod: sampler animationInterpolationMethod;
		yourself
]

{ #category : #accessing }
WDIGLTF2AnimationChannel >> sampler [
	^ sampler
]

{ #category : #accessing }
WDIGLTF2AnimationChannel >> sampler: anObject [
	sampler := anObject
]

{ #category : #'as yet unclassified' }
WDIGLTF2AnimationChannel >> skinnedModelAnimationChannelClass [
	^ TargetPropertyToClassMap at: targetProperty
]

{ #category : #accessing }
WDIGLTF2AnimationChannel >> targetArmature [

	^ targetArmature
]

{ #category : #accessing }
WDIGLTF2AnimationChannel >> targetArmature: anObject [

	targetArmature := anObject
]

{ #category : #accessing }
WDIGLTF2AnimationChannel >> targetBoneIndex [
	^ targetBoneIndex
]

{ #category : #accessing }
WDIGLTF2AnimationChannel >> targetBoneIndex: anObject [
	targetBoneIndex := anObject
]

{ #category : #accessing }
WDIGLTF2AnimationChannel >> targetProperty [
	^ targetProperty
]

{ #category : #accessing }
WDIGLTF2AnimationChannel >> targetProperty: anObject [
	targetProperty := anObject
]
