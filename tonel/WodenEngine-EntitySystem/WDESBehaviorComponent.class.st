Class {
	#name : #WDESBehaviorComponent,
	#superclass : #WDESComponent,
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #'as yet unclassified' }
WDESBehaviorComponent >> attachToEntity: anEntity [
	anEntity behaviorComponent: self
]

{ #category : #'as yet unclassified' }
WDESBehaviorComponent >> detachFromEntity: anEntity [
	anEntity behaviorComponent: nil
]
