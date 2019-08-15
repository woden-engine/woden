Class {
	#name : #WDESCharacterDisplacementStrategy,
	#superclass : #Object,
	#instVars : [
		'character'
	],
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #'as yet unclassified' }
WDESCharacterDisplacementStrategy >> activateUseCommand [
	^ character activateUseActuator
]

{ #category : #simulation }
WDESCharacterDisplacementStrategy >> adjustHeadAndBodyOrientations [
	| headAngle |
	headAngle := character headAngle.
	
	self isRotatingFullBody ifTrue: [ 
		character
			bodyOrientation: (WMMatrix3F yrot: headAngle y) * (WMMatrix3F xrot: headAngle x);
			headOrientation: WMMatrix3F identity.
	] ifFalse: [ 
		character
			bodyOrientation: (WMMatrix3F yrot: headAngle y);
			headOrientation: (WMMatrix3F xrot: headAngle x)
	].

]

{ #category : #accessing }
WDESCharacterDisplacementStrategy >> buoyancy [
	^ 0
]

{ #category : #accessing }
WDESCharacterDisplacementStrategy >> character [
	^ character
]

{ #category : #accessing }
WDESCharacterDisplacementStrategy >> character: anObject [
	character := anObject
]

{ #category : #testing }
WDESCharacterDisplacementStrategy >> isRotatingFullBody [
	^ true
]

{ #category : #testing }
WDESCharacterDisplacementStrategy >> isUnderwaterDisplacementStrategy [
	^ false
]

{ #category : #actions }
WDESCharacterDisplacementStrategy >> jump [
	"Jump action"
]

{ #category : #simulation }
WDESCharacterDisplacementStrategy >> postPhysicsTick: delta [
	self usingPhysicsObject ifTrue: [ 
		character ownerEntity transform: (WMReversibleAffineTransformF identity
			orthonormal: character bodyOrientation translation: character ghostObject position).
	]

]

{ #category : #simulation }
WDESCharacterDisplacementStrategy >> prePhysicsTick: delta [
]

{ #category : #simulation }
WDESCharacterDisplacementStrategy >> tick: delta [
]

{ #category : #hooks }
WDESCharacterDisplacementStrategy >> usingPhysicsObject [
	^ true
]
