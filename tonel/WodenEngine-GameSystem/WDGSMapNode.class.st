Class {
	#name : #WDGSMapNode,
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
	#category : #'WodenEngine-GameSystem-Level'
}

{ #category : #'class initialization' }
WDGSMapNode class >> initialize [
	super initialize.
	
	SelectionColor := Color orange.
	LastSelectionColor := Color orange lighter lighter lighter.
]

{ #category : #changing }
WDGSMapNode >> changedSelectionState [
]

{ #category : #accessing }
WDGSMapNode >> engine [
	^ self scene ifNotNil: [:scene | scene engine]
]

{ #category : #initialization }
WDGSMapNode >> initialize [
	super initialize.
	selected := false.
	lastSelected := false.
]

{ #category : #testing }
WDGSMapNode >> isBrush [
	^ false
]

{ #category : #testing }
WDGSMapNode >> isEntity [
	^ false
]

{ #category : #accessing }
WDGSMapNode >> isPointSelected [
	^ false
]

{ #category : #accessing }
WDGSMapNode >> lastSelected [
	^ lastSelected
]

{ #category : #accessing }
WDGSMapNode >> lastSelected: anObject [
	lastSelected := anObject.
	self changedSelectionState.
]

{ #category : #'as yet unclassified' }
WDGSMapNode >> postCopy [
	super postCopy.
	selected := false.
	lastSelected := false.
]

{ #category : #memento }
WDGSMapNode >> restoreTransformMemento: memento [
]

{ #category : #accessing }
WDGSMapNode >> selected [
	^ selected
]

{ #category : #accessing }
WDGSMapNode >> selected: anObject [
	selected := anObject.
	self changedSelectionState.
]

{ #category : #'map events' }
WDGSMapNode >> simulateTime: delta [
	"This called only when a map element has subscribed to time events"
]

{ #category : #'map events' }
WDGSMapNode >> spawn [
]

{ #category : #'map events' }
WDGSMapNode >> subscribeToTimeEvents [
	self map registerTimeListener: self
]

{ #category : #enumerating }
WDGSMapNode >> textureTransformsDo: aBlock [
]

{ #category : #memento }
WDGSMapNode >> transformMemento [
	^ nil
]

{ #category : #'map events' }
WDGSMapNode >> unsubscribeToTimeEvents [
	self map unregisterTimeListener: self
]
