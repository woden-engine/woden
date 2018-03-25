Class {
	#name : #WDCShaderSignatureSpec,
	#superclass : #Object,
	#instVars : [
		'name',
		'elements'
	],
	#category : 'WodenEngine-Core-Shaders'
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
	
]

{ #category : #accessing }
WDCShaderSignatureSpec >> name [
	^ name
]

{ #category : #accessing }
WDCShaderSignatureSpec >> name: anObject [
	name := anObject
]
