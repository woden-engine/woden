Class {
	#name : #WDESNode,
	#superclass : #Object,
	#instVars : [
		'name'
	],
	#pools : [
		'OSKeySymbols',
		'WDESTypeNameConstants'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #adding }
WDESNode >> addedToEntity: anEntity [
]

{ #category : #notifications }
WDESNode >> addedToPhysicsWorld: aPhysicsWorld [
]

{ #category : #notifications }
WDESNode >> addedToScene: aScene [
]

{ #category : #accessing }
WDESNode >> name [
	^ name
]

{ #category : #accessing }
WDESNode >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDESNode >> physicsWorld [
	^ self subclassResponsibility
]

{ #category : #adding }
WDESNode >> removedFromEntity: anEntity [
]

{ #category : #notifications }
WDESNode >> removedFromPhysicsWorld: aPhysicsWorld [
]

{ #category : #notifications }
WDESNode >> removedFromScene: aScene [
]

{ #category : #accessing }
WDESNode >> scene [
	^ self subclassResponsibility
]

{ #category : #accessing }
WDESNode >> sector [
	^ self subclassResponsibility
]

{ #category : #simulation }
WDESNode >> tick: delta [
]

{ #category : #accessing }
WDESNode >> universe [
	^ self subclassResponsibility
]
