Class {
	#name : #WDCShaderSignatureSpec,
	#superclass : #Object,
	#instVars : [
		'name',
		'elements',
		'pushConstantsSize'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #building }
WDCShaderSignatureSpec >> bank: bankName with: aBlock [
	| bank |
	bank := WDCShaderSignatureSpecBank new name: bankName; index: elements size.
	elements add: bank.
	aBlock value: bank.
	^ bank
]

{ #category : #accessing }
WDCShaderSignatureSpec >> elements [
	^ elements
]

{ #category : #initialization }
WDCShaderSignatureSpec >> initialize [
	super initialize.
	elements := OrderedCollection new.
	pushConstantsSize := 0.
]

{ #category : #accessing }
WDCShaderSignatureSpec >> name [
	^ name
]

{ #category : #accessing }
WDCShaderSignatureSpec >> name: anObject [
	name := anObject
]

{ #category : #building }
WDCShaderSignatureSpec >> pushConstant: constantName [
	^ self pushConstant: constantName size: 4
]

{ #category : #building }
WDCShaderSignatureSpec >> pushConstant: constantName size: constantSize [
	| bank |
	bank := WDCShaderSignatureSpecPushConstant new name: constantName; offset: pushConstantsSize; size: constantSize.
	pushConstantsSize := pushConstantsSize + constantSize.
	elements add: bank.
	^ bank
]

{ #category : #accessing }
WDCShaderSignatureSpec >> pushConstantsSize [
	^ pushConstantsSize
]
