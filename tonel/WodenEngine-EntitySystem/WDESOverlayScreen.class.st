Class {
	#name : #WDESOverlayScreen,
	#superclass : #Object,
	#instVars : [
		'babylonDefaultFont',
		'engine'
	],
	#category : #'WodenEngine-EntitySystem-Overlays'
}

{ #category : #accessing }
WDESOverlayScreen >> babylonDefaultFont [
	^ babylonDefaultFont ifNil: [ babylonDefaultFont := engine babylonDriver font: (LogicalFont familyName: 'Arial' pointSize: 20) ]
]

{ #category : #testing }
WDESOverlayScreen >> drawOnBabylonCanvas: canvas [
	"This is the place for rendering the overlay screen."
]

{ #category : #accessing }
WDESOverlayScreen >> engine [
	^ engine
]

{ #category : #accessing }
WDESOverlayScreen >> engine: anObject [
	engine := anObject
]

{ #category : #testing }
WDESOverlayScreen >> isAlive [
	^ true
]

{ #category : #testing }
WDESOverlayScreen >> tick: delta [
	"This is the place for doing time based updates."
]
