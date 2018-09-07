Class {
	#name : #WDGSItemBehavior,
	#superclass : #WDGSBehavior,
	#category : #'WodenEngine-GameSystem-Item'
}

{ #category : #'double dispatch' }
WDGSItemBehavior >> activateOnPlayer: aPlayer [
	entity removeFromMap.
]

{ #category : #accessing }
WDGSItemBehavior >> modelName [
	self subclassResponsibility
]

{ #category : #'map events' }
WDGSItemBehavior >> setupPhysicsComponent: aPhysicsComponent [
	super setupPhysicsComponent: aPhysicsComponent.
	aPhysicsComponent
		makeRigidBody;
		mass: 1.0;
		boxCollisionShape: self localBoundingBox
]

{ #category : #'map events' }
WDGSItemBehavior >> spawn [
	| mesh |
	mesh := self setMeshNamed: self modelName.
	self setBoundingBox: mesh boundingBox.
	entity ensurePhysicsComponent.
	
	self subscribeToTouchEvents.
]

{ #category : #events }
WDGSItemBehavior >> touch: anEntity [
	anEntity sendToBehaviors: #pickItem: withArguments: { self }
]
