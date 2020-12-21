Class {
	#name : #WDESOverlayScreen,
	#superclass : #Object,
	#instVars : [
		'engine'
	],
	#category : #'WodenEngine-EntitySystem-Overlays'
}

{ #category : #testing }
WDESOverlayScreen >> buildUISceneGraphWith: builder [
	^ builder null
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
