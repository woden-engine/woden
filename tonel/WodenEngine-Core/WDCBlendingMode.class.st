Class {
	#name : #WDCBlendingMode,
	#superclass : #Object,
	#instVars : [
		'enabled',
		'sourceFactor',
		'destFactor',
		'operation',
		'sourceAlphaFactor',
		'destAlphaFactor',
		'alphaOperation'
	],
	#classVars : [
		'Add',
		'AddAlpha',
		'AlphaOver',
		'AlphaOverCompose',
		'Replace'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #'blending modes' }
WDCBlendingMode class >> add [
	^ Add
]

{ #category : #'blending modes' }
WDCBlendingMode class >> addAlpha [
	^ AddAlpha
]

{ #category : #'blending modes' }
WDCBlendingMode class >> alphaOver [
	^ AlphaOver
]

{ #category : #'blending modes' }
WDCBlendingMode class >> alphaOverCompose [
	^ AlphaOverCompose
]

{ #category : #initialization }
WDCBlendingMode class >> initialize [
	Replace := self sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_ZERO.
	AlphaOver := self sourceFactor: AGPU_BLENDING_SRC_ALPHA destFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA.
	AlphaOverCompose := self sourceFactor: AGPU_BLENDING_SRC_ALPHA destFactor: AGPU_BLENDING_INVERTED_SRC_ALPHA sourceFactorAlpha: AGPU_BLENDING_ONE destFactorAlpha: AGPU_BLENDING_INVERTED_SRC_ALPHA.
	Add := self sourceFactor: AGPU_BLENDING_ONE destFactor: AGPU_BLENDING_ONE.
	AddAlpha := self sourceFactor: AGPU_BLENDING_SRC_ALPHA destFactor: AGPU_BLENDING_ONE.
]

{ #category : #'blending modes' }
WDCBlendingMode class >> replace [
	^ Replace
]

{ #category : #construction }
WDCBlendingMode class >> sourceFactor: sourceFactor destFactor: destFactor [
	^ self new
		enabled: true;
		sourceFactor: sourceFactor;
		destFactor: destFactor;
		operation: AGPU_BLENDING_OPERATION_ADD;
		sourceAlphaFactor: sourceFactor;
		destAlphaFactor: destFactor;
		alphaOperation: AGPU_BLENDING_OPERATION_ADD;
		yourself
]

{ #category : #construction }
WDCBlendingMode class >> sourceFactor: sourceFactor destFactor: destFactor sourceFactorAlpha: sourceFactorAlpha destFactorAlpha: destFactorAlpha [
	^ self new
		enabled: true;
		sourceFactor: sourceFactor;
		destFactor: destFactor;
		operation: AGPU_BLENDING_OPERATION_ADD;
		sourceAlphaFactor: sourceFactorAlpha;
		destAlphaFactor: destFactorAlpha;
		alphaOperation: AGPU_BLENDING_OPERATION_ADD;
		yourself
]

{ #category : #comparing }
WDCBlendingMode >> = other [
	^ self class == other class and:
	[ enabled = other enabled and:
	[ sourceFactor = other sourceFactor and:
	[ destFactor = other destFactor and:
	[ operation = other operation and:
	[ sourceAlphaFactor = other sourceAlphaFactor and:
	[ destAlphaFactor = other destAlphaFactor and:
	[ alphaOperation = other alphaOperation]]]]]]]
]

{ #category : #accessing }
WDCBlendingMode >> alphaOperation [
	^ alphaOperation
]

{ #category : #accessing }
WDCBlendingMode >> alphaOperation: anObject [
	alphaOperation := anObject
]

{ #category : #converting }
WDCBlendingMode >> asPipelineStateBlendingState [
	| result |
	result := WDCPipelineStateBlendingState new.
	result enabled: enabled;
		targetMask: -1;
		sourceFactor: sourceFactor;
		destFactor: destFactor;
		operation: operation;
		sourceAlphaFactor: sourceAlphaFactor;
		destAlphaFactor: destAlphaFactor;
		alphaOperation: alphaOperation.
	^ result
]

{ #category : #accessing }
WDCBlendingMode >> destAlphaFactor [
	^ destAlphaFactor
]

{ #category : #accessing }
WDCBlendingMode >> destAlphaFactor: anObject [
	destAlphaFactor := anObject
]

{ #category : #accessing }
WDCBlendingMode >> destFactor [
	^ destFactor
]

{ #category : #accessing }
WDCBlendingMode >> destFactor: anObject [
	destFactor := anObject
]

{ #category : #accessing }
WDCBlendingMode >> enabled [
	^ enabled
]

{ #category : #accessing }
WDCBlendingMode >> enabled: anObject [
	enabled := anObject
]

{ #category : #comparing }
WDCBlendingMode >> hash [
	^ enabled hash bitXor:
	( sourceFactor hash bitXor:
	( destFactor hash bitXor:
	( operation hash bitXor:
	( sourceAlphaFactor hash bitXor:
	( destAlphaFactor hash bitXor:
	( alphaOperation hash))))))
]

{ #category : #accessing }
WDCBlendingMode >> operation [
	^ operation
]

{ #category : #accessing }
WDCBlendingMode >> operation: anObject [
	operation := anObject
]

{ #category : #accessing }
WDCBlendingMode >> sourceAlphaFactor [
	^ sourceAlphaFactor
]

{ #category : #accessing }
WDCBlendingMode >> sourceAlphaFactor: anObject [
	sourceAlphaFactor := anObject
]

{ #category : #accessing }
WDCBlendingMode >> sourceFactor [
	^ sourceFactor
]

{ #category : #accessing }
WDCBlendingMode >> sourceFactor: anObject [
	sourceFactor := anObject
]
