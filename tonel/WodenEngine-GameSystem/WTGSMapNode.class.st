Class {
	#name : #WTGSMapNode,
	#superclass : #Object,
	#instVars : [
		'selected',
		'lastSelected'
	],
	#classVars : [
		'LastSelectionColor',
		'SelectionColor'
	],
	#pools : [
		'OSKeySymbols'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #'class initialization' }
WTGSMapNode class >> initialize [
	super initialize.
	
	SelectionColor := Color orange.
	LastSelectionColor := Color orange lighter lighter lighter.
]

{ #category : #changing }
WTGSMapNode >> changedSelectionState [
]

{ #category : #accessing }
WTGSMapNode >> engine [
	^ self scene engine
]

{ #category : #initialization }
WTGSMapNode >> initialize [
	super initialize.
	selected := false.
	lastSelected := false.
]

{ #category : #testing }
WTGSMapNode >> isBrush [
	^ false
]

{ #category : #testing }
WTGSMapNode >> isEntity [
	^ false
]

{ #category : #accessing }
WTGSMapNode >> isPointSelected [
	^ false
]

{ #category : #accessing }
WTGSMapNode >> lastSelected [
	^ lastSelected
]

{ #category : #accessing }
WTGSMapNode >> lastSelected: anObject [
	lastSelected := anObject.
	self changedSelectionState.
]

{ #category : #'as yet unclassified' }
WTGSMapNode >> postCopy [
	super postCopy.
	selected := false.
	lastSelected := false.
]

{ #category : #memento }
WTGSMapNode >> restoreTransformMemento: memento [
]

{ #category : #accessing }
WTGSMapNode >> selected [
	^ selected
]

{ #category : #accessing }
WTGSMapNode >> selected: anObject [
	selected := anObject.
	self changedSelectionState.
]

{ #category : #'map events' }
WTGSMapNode >> simulateTime: delta [
	"This called only when a map element has subscribed to time events"
]

{ #category : #'map events' }
WTGSMapNode >> spawn [
]

{ #category : #'map events' }
WTGSMapNode >> subscribeToTimeEvents [
	self map registerTimeListener: self
]

{ #category : #enumerating }
WTGSMapNode >> textureTransformsDo: aBlock [
]

{ #category : #memento }
WTGSMapNode >> transformMemento [
	^ nil
]

{ #category : #'map events' }
WTGSMapNode >> unsubscribeToTimeEvents [
	self map unregisterTimeListener: self
]
