Class {
	#name : #WDAESGameLogic,
	#superclass : #Object,
	#instVars : [
		'universe'
	],
	#category : #'WodenEngine-EntitySystem-Application'
}

{ #category : #'as yet unclassified' }
WDAESGameLogic >> spawnPlayer [
	| playerEntity |
	playerEntity := WDESGenericEntity new.
	playerEntity addComponent: WDESFPSPlayerBehaviorComponent new.
	universe activeSector addEntity: playerEntity toSpawnPoint: universe findAnyPlayerStartPoint.
	
	^ playerEntity
]

{ #category : #simulation }
WDAESGameLogic >> tick: delta [
]

{ #category : #accessing }
WDAESGameLogic >> universe [
	^ universe
]

{ #category : #accessing }
WDAESGameLogic >> universe: anObject [
	universe := anObject
]
