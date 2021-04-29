Class {
	#name : #WDESPointEntity,
	#superclass : #WDESGenericEntity,
	#instVars : [
		'radius'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #'as yet unclassified' }
WDESPointEntity >> isPlayerStartPoint [
	^ typeName == EntityTypeName_PlayerStartPoint
]

{ #category : #testing }
WDESPointEntity >> isPointEntity [
	^ true
]

{ #category : #'as yet unclassified' }
WDESPointEntity >> makePlayerStartPoint [
	^ self typeName: EntityTypeName_PlayerStartPoint
]
