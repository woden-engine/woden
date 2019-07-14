Class {
	#name : #WDESPointEntity,
	#superclass : #WDESGenericEntity,
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #'as yet unclassified' }
WDESPointEntity >> isPlayerStartPoint [
	^ typeName == EntityTypeName_InfoPlayerStart
]

{ #category : #testing }
WDESPointEntity >> isPointEntity [
	^ true
]

{ #category : #'as yet unclassified' }
WDESPointEntity >> makePlayerStartPoint [
	^ self typeName: EntityTypeName_InfoPlayerStart
]
