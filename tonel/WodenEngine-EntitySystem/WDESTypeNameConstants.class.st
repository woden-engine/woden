Class {
	#name : #WDESTypeNameConstants,
	#superclass : #SharedPool,
	#classVars : [
		'EntityTypeName_PlayerStartPoint'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #initialization }
WDESTypeNameConstants class >> initialize [
	EntityTypeName_PlayerStartPoint := #PlayerStartPoint.
]
