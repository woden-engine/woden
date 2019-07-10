Class {
	#name : #WDESComponent,
	#superclass : #WDESNode,
	#instVars : [
		'ownerEntity'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #'as yet unclassified' }
WDESComponent >> attachToEntity: anEntity [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDESComponent >> detachFromEntity: anEntity [
	self subclassResponsibility
]

{ #category : #accessing }
WDESComponent >> ownerEntity [
	^ ownerEntity
]

{ #category : #accessing }
WDESComponent >> ownerEntity: anObject [
	ownerEntity := anObject
]

{ #category : #copying }
WDESComponent >> postCopy [
	ownerEntity := nil.
]
