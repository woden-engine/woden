Class {
	#name : #WDESPhysicsComponent,
	#superclass : #WDESComponentWithShape,
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #'as yet unclassified' }
WDESPhysicsComponent >> attachToEntity: anEntity [
	anEntity physicsComponent: self
]

{ #category : #'as yet unclassified' }
WDESPhysicsComponent >> detachFromEntity: anEntity [
	anEntity physicsComponent: nil
]
