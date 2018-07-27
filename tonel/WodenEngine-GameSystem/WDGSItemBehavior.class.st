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
WDGSItemBehavior >> spawn [
	| mesh |
	mesh := self setMeshNamed: self modelName.
	self setBoundingBox: mesh boundingBox.
	
	self subscribeToTouchEvents.
]

{ #category : #events }
WDGSItemBehavior >> touch: anEntity [
	anEntity sendToBehaviors: #pickItem: withArguments: { self }
]
