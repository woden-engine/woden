Class {
	#name : #WDESAbstractEntity,
	#superclass : #WDESNode,
	#instVars : [
		'parent',
		'children',
		'sceneComponent',
		'physicsComponent',
		'behaviorComponent'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #adding }
WDESAbstractEntity >> addChild: aChild [
	self assert: aChild parent isNil.
	children add: aChild.
	aChild parent: self.
	
	aChild addedToEntity: self
]

{ #category : #adding }
WDESAbstractEntity >> addComponent: aComponent [
	aComponent attachToEntity: self
]

{ #category : #accessing }
WDESAbstractEntity >> behaviorComponent [
	^ behaviorComponent
]

{ #category : #accessing }
WDESAbstractEntity >> behaviorComponent: anObject [
	behaviorComponent ifNotNil: [ behaviorComponent ownerEntity: nil ].
	behaviorComponent := anObject.
	behaviorComponent ifNotNil: [ behaviorComponent ownerEntity: self ].
]

{ #category : #initialization }
WDESAbstractEntity >> initialize [
	super initialize.
	children := OrderedCollection new.
]

{ #category : #accessing }
WDESAbstractEntity >> physicsComponent [
	^ physicsComponent
]

{ #category : #accessing }
WDESAbstractEntity >> physicsComponent: anObject [
	physicsComponent ifNotNil: [ physicsComponent ownerEntity: nil ].
	physicsComponent := anObject.
	physicsComponent ifNotNil: [ physicsComponent ownerEntity: self ].
]

{ #category : #accessing }
WDESAbstractEntity >> sceneComponent [
	^ sceneComponent
]

{ #category : #accessing }
WDESAbstractEntity >> sceneComponent: anObject [
	sceneComponent ifNotNil: [ sceneComponent ownerEntity: nil ].
	sceneComponent := anObject.
	sceneComponent ifNotNil: [ sceneComponent ownerEntity: self ].
]

{ #category : #transforming }
WDESAbstractEntity >> transform [
	^ WMReversibleAffineTransformF identity
]
