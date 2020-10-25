Class {
	#name : #WDIGLTF2AnimationSampler,
	#superclass : #Object,
	#instVars : [
		'inputAccessor',
		'outputAccessor',
		'interpolationAlgorithm'
	],
	#classVars : [
		'InterpolationAlgorithmToInterpolationMethodMap'
	],
	#category : #'WodenEngine-Importers-GLTF'
}

{ #category : #'class initialization' }
WDIGLTF2AnimationSampler class >> initialize [
	InterpolationAlgorithmToInterpolationMethodMap := Dictionary newFromPairs: { 
		'LINEAR' . WDCAnimationInterpolationMethod linear.
		'STEP' . WDCAnimationInterpolationMethod step.
		'CUBICSPLINE' . WDCAnimationInterpolationMethod cubicSpline.
	}

]

{ #category : #'as yet unclassified' }
WDIGLTF2AnimationSampler >> animationInterpolationMethod [
	^ InterpolationAlgorithmToInterpolationMethodMap at: interpolationAlgorithm ifAbsent: [ WDCAnimationStepInterpolationMethod uniqueInstance ]
]

{ #category : #accessing }
WDIGLTF2AnimationSampler >> inputAccessor [
	^ inputAccessor
]

{ #category : #accessing }
WDIGLTF2AnimationSampler >> inputAccessor: anObject [
	inputAccessor := anObject
]

{ #category : #accessing }
WDIGLTF2AnimationSampler >> inputMaxValue [
	^ inputAccessor max
]

{ #category : #accessing }
WDIGLTF2AnimationSampler >> inputMinValue [
	^ inputAccessor min
]

{ #category : #accessing }
WDIGLTF2AnimationSampler >> inputValues [
	^ inputAccessor decodeContentAsArray
]

{ #category : #accessing }
WDIGLTF2AnimationSampler >> interpolationAlgorithm [
	^ interpolationAlgorithm
]

{ #category : #accessing }
WDIGLTF2AnimationSampler >> interpolationAlgorithm: anObject [
	interpolationAlgorithm := anObject
]

{ #category : #accessing }
WDIGLTF2AnimationSampler >> outputAccessor [
	^ outputAccessor
]

{ #category : #accessing }
WDIGLTF2AnimationSampler >> outputAccessor: anObject [
	outputAccessor := anObject
]

{ #category : #accessing }
WDIGLTF2AnimationSampler >> outputValues [
	^ outputAccessor decodeContentAsArray
]
