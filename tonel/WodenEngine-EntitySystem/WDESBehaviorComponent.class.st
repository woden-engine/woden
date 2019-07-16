Class {
	#name : #WDESBehaviorComponent,
	#superclass : #WDESComponent,
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #testing }
WDESBehaviorComponent >> isBehaviorComponent [
	^ true
]

{ #category : #'as yet unclassified' }
WDESBehaviorComponent >> onTouchWithEntity: collisionEntity atCollisionObject: collisionObject [
]

{ #category : #'as yet unclassified' }
WDESBehaviorComponent >> sendEnvironmentSensorEvent: environmentEventSelector from: senderComponent [
	"By default, we ignore these messages."
]

{ #category : #'as yet unclassified' }
WDESBehaviorComponent >> sendInputEvent: inputEventSelector with: anEvent [
	"By default, we ignore these messages."
]
