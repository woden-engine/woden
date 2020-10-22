Class {
	#name : #WDEScalarProperty,
	#superclass : #WDEStringProperty,
	#instVars : [
		'minimum',
		'maximum'
	],
	#category : #'WodenEngine-Editor-Model-Properties'
}

{ #category : #accessing }
WDEScalarProperty >> maximum [
	^ maximum
]

{ #category : #accessing }
WDEScalarProperty >> maximum: anObject [
	maximum := anObject
]

{ #category : #accessing }
WDEScalarProperty >> minimum [
	^ minimum
]

{ #category : #accessing }
WDEScalarProperty >> minimum: anObject [
	minimum := anObject
]

{ #category : #parsing }
WDEScalarProperty >> parseText: text [
	^ text asNumber
]
