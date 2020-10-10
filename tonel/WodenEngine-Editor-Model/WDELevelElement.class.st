Class {
	#name : #WDELevelElement,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #testing }
WDELevelElement class >> isAbstract [
	^ self == WDELevelElement
]

{ #category : #visiting }
WDELevelElement >> accept: visitor [
	^ self subclassResponsibility
]

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

{ #category : #accessing }
WDELevelElement >> treeDisplayName [
	^ self name
]
