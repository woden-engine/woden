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

{ #category : #'as yet unclassified' }
WDELevelElement >> addedToLevel: level [
	level announceAddedElement: self.
	self children do: [ :each | each addedToLevel: level ]
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
WDELevelElement >> is2DLevelElement [
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
WDELevelElement >> isInSector2D [
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
WDELevelElement >> level [
	^ self parent ifNotNil: [ :p | p level ]
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
WDELevelElement >> parent [
	^ nil
]

{ #category : #accessing }
WDELevelElement >> position [
	^ Float32x3 zeros
]

{ #category : #accessing }
WDELevelElement >> position: aPosition [
	"By default do nothing"
]

{ #category : #'ray casting' }
WDELevelElement >> rayCast: ray [
	^ nil
]

{ #category : #'as yet unclassified' }
WDELevelElement >> removedFromLevel: level [
	self children do: [ :each | each removedFromLevel: level ].
	level announceRemovedElement: self.

]

{ #category : #memento }
WDELevelElement >> restoreTransformStateMemento: memento [
]

{ #category : #accessing }
WDELevelElement >> sectorLayer [
	^ self parent ifNotNil: [ :p | p sectorLayer ]
]

{ #category : #memento }
WDELevelElement >> transformStateMemento [
	^ nil
]

{ #category : #transforms }
WDELevelElement >> transformWith: transform [
]

{ #category : #transforms }
WDELevelElement >> translateBy: translation [
]

{ #category : #accessing }
WDELevelElement >> treeDisplayName [
	^ self name
]
