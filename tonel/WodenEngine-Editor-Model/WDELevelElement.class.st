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

{ #category : #testing }
WDELevelElement >> isCollisionComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isVisualComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isVisualComponent2D [
	^ false
]

{ #category : #testing }
WDELevelElement >> isVisualComponent3D [
	^ false
]

{ #category : #accessing }
WDELevelElement >> name [
	^ name ifNil: [ name := '' ]
]

{ #category : #accessing }
WDELevelElement >> name: aString [
	name := aString.
]

{ #category : #'ray casting' }
WDELevelElement >> rayCast: ray [
	^ nil
]

{ #category : #accessing }
WDELevelElement >> treeDisplayName [
	^ self name
]
