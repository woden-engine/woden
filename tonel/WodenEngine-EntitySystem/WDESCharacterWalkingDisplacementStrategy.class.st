Class {
	#name : #WDESCharacterWalkingDisplacementStrategy,
	#superclass : #WDESAnimalCharacterDisplacementStrategy,
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #simulation }
WDESCharacterWalkingDisplacementStrategy >> adjustHeadAndBodyOrientations [
	| headAngle |
	headAngle := character headAngle.
	
	character
		bodyOrientation: (WMMatrix3F yrot: headAngle y);
		headOrientation: (WMMatrix3F xrot: headAngle x).
]

{ #category : #testing }
WDESCharacterWalkingDisplacementStrategy >> isRotatingFullBody [
	^ false
]

{ #category : #testing }
WDESCharacterWalkingDisplacementStrategy >> movementAxes [
	^ WMVector3F x: 1.0 y: 0.0 z: 1.0
]

{ #category : #simulation }
WDESCharacterWalkingDisplacementStrategy >> tickLinearMovement: delta [
	character linearAcceleration: (character linearAcceleration y: 0.0).
	character leftStickDirection z > 0.0 ifTrue: [ character jump ].
	super tickLinearMovement: delta
]
