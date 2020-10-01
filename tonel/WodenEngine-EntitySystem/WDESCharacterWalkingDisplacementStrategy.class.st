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
		bodyOrientation: (Float32x3x3 yRotation: headAngle y);
		headOrientation: (Float32x3x3 xRotation: headAngle x).
]

{ #category : #testing }
WDESCharacterWalkingDisplacementStrategy >> isRotatingFullBody [
	^ false
]

{ #category : #testing }
WDESCharacterWalkingDisplacementStrategy >> movementAxes [
	^ Float32x3 x: 1.0 y: 0.0 z: 1.0
]

{ #category : #simulation }
WDESCharacterWalkingDisplacementStrategy >> tickLinearMovement: delta [
	character linearAcceleration: (character linearAcceleration y: 0.0).
	character leftStickDirection z > 0.0 ifTrue: [ character jump ].
	super tickLinearMovement: delta
]
