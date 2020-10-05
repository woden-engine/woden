Class {
	#name : #WDELevelElement,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #accessing }
WDELevelElement >> children [
	^ #()
]

{ #category : #initialization }
WDELevelElement >> initialize [
	super initialize.
]

{ #category : #accessing }
WDELevelElement >> name [
	^ name ifNil: [ name := '' ]
]

{ #category : #accessing }
WDELevelElement >> name: aString [
	name := aString.
]
