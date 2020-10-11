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

{ #category : #'ray casting' }
WDELevelElement >> intersectsFrustum: frustum [
	^ false
]

{ #category : #testing }
WDELevelElement >> isCollisionComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isEntity [
	^ false
]

{ #category : #testing }
WDELevelElement >> isEntityComponent [
	^ false
]

{ #category : #testing }
WDELevelElement >> isLevel [
	^ false
]

{ #category : #testing }
WDELevelElement >> isPointEntity [
	^ false
]

{ #category : #testing }
WDELevelElement >> isSector [
	^ false
]

{ #category : #testing }
WDELevelElement >> isSectorLayer [
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

{ #category : #memento }
WDELevelElement >> restoreTransformStateMemento: memento [
]

{ #category : #memento }
WDELevelElement >> transformStateMemento [
	^ nil
]

{ #category : #transforms }
WDELevelElement >> translateBy: translation [
]

{ #category : #accessing }
WDELevelElement >> treeDisplayName [
	^ self name
]
