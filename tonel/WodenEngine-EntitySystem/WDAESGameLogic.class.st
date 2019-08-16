Class {
	#name : #WDAESGameLogic,
	#superclass : #Object,
	#instVars : [
		'universe',
		'globalOverlays'
	],
	#category : #'WodenEngine-EntitySystem-Application'
}

{ #category : #adding }
WDAESGameLogic >> addGlobalOverlay: anOverlay [
	globalOverlays add: anOverlay
]

{ #category : #rendering }
WDAESGameLogic >> drawOnBabylonCanvas: aCanvas [
	globalOverlays do: [ :overlay | overlay drawOnBabylonCanvas: aCanvas ]
]

{ #category : #accessing }
WDAESGameLogic >> engine [
	^ universe engine
]

{ #category : #initialization }
WDAESGameLogic >> initialize [
	super initialize.
	globalOverlays := OrderedCollection new.
]

{ #category : #'as yet unclassified' }
WDAESGameLogic >> spawnPlayer [
	| playerEntity |
	playerEntity := WDESPlayerEntity new.
	playerEntity addComponent: WDESFPSPlayerBehaviorComponent new.
	universe activeSector addEntity: playerEntity toSpawnPoint: universe findAnyPlayerStartPoint.
	
	^ playerEntity
]

{ #category : #simulation }
WDAESGameLogic >> tick: delta [
	globalOverlays := globalOverlays collect: [:ov | ov tick: delta . ov ] thenSelect: #isAlive.
]

{ #category : #accessing }
WDAESGameLogic >> universe [
	^ universe
]

{ #category : #accessing }
WDAESGameLogic >> universe: anObject [
	universe := anObject
]
