Class {
	#name : #WTGSItemBehavior,
	#superclass : #WTGSBehavior,
	#category : 'WodenEngine-GameSystem-Item'
}

{ #category : #'double dispatch' }
WTGSItemBehavior >> activateOnPlayer: aPlayer [
	entity removeFromMap.
]

{ #category : #accessing }
WTGSItemBehavior >> modelName [
	self subclassResponsibility
]

{ #category : #'map events' }
WTGSItemBehavior >> spawn [
	| mesh |
	mesh := self setMeshNamed: self modelName.
	self setBoundingBox: mesh boundingBox.
	
	self subscribeToTouchEvents.
]

{ #category : #events }
WTGSItemBehavior >> touch: anEntity [
	anEntity sendToBehaviors: #pickItem: withArguments: { self }
]
