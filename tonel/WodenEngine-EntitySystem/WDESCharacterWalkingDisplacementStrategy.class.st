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
		headOrientation: (WMMatrix3F xrot: headAngle x);
		linearAcceleration: (character linearAcceleration y: 0.0).
]

{ #category : #testing }
WDESCharacterWalkingDisplacementStrategy >> isRotatingFullBody [
	^ false
]

{ #category : #simulation }
WDESCharacterWalkingDisplacementStrategy >> tickLinearMovement: delta [
	character linearAcceleration: (character linearAcceleration y: 0.0).
	super tickLinearMovement: delta
]
