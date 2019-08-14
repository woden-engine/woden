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
