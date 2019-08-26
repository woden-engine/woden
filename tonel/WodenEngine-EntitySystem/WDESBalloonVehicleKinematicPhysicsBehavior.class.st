Class {
	#name : #WDESBalloonVehicleKinematicPhysicsBehavior,
	#superclass : #WDESKinematicPhysicsBehavior,
	#instVars : [
		'engineDirection',
		'altitudeDirection',
		'linearVelocity',
		'linearAcceleration',
		'linearDamping',
		'terminalSpeed',
		'angularVelocity',
		'minimalAltitude',
		'turnDirection',
		'currentDriver'
	],
	#category : #'WodenEngine-EntitySystem-Samples'
}

{ #category : #accessing }
WDESBalloonVehicleKinematicPhysicsBehavior >> altitudeDirection [
	^ altitudeDirection
]

{ #category : #accessing }
WDESBalloonVehicleKinematicPhysicsBehavior >> altitudeDirection: anObject [
	altitudeDirection := anObject
]

{ #category : #initialization }
WDESBalloonVehicleKinematicPhysicsBehavior >> currentDriver: aDriver [
	currentDriver := aDriver
]

{ #category : #accessing }
WDESBalloonVehicleKinematicPhysicsBehavior >> engineDirection [
	^ engineDirection
]

{ #category : #accessing }
WDESBalloonVehicleKinematicPhysicsBehavior >> engineDirection: anObject [
	engineDirection := anObject
]

{ #category : #initialization }
WDESBalloonVehicleKinematicPhysicsBehavior >> initialize [
	super initialize.
	terminalSpeed := 1.0.
	altitudeDirection := 0.0.
	engineDirection := 0.0.
	turnDirection := 0.0.
	
	linearVelocity := WMVector3F zero.
	linearAcceleration := WMVector3F zero.
	
	linearDamping := 0.5.
	
	angularVelocity := 0.0.
	minimalAltitude := 0.0.
]

{ #category : #initialization }
WDESBalloonVehicleKinematicPhysicsBehavior >> maxEngineAcceleration [
	^ terminalSpeed / linearDamping
]

{ #category : #initialization }
WDESBalloonVehicleKinematicPhysicsBehavior >> prePhysicsTick: delta [
	| engineAcceleration gravity buoyancy oldTransform newTranslation |

	oldTransform := self ownerEntity transform.
	engineAcceleration := WMVector3F z: engineDirection negated * self maxEngineAcceleration.
	
	gravity := WMVector3F y: -9.8.
	buoyancy := WMVector3F y: (0.0 interpolateTo: 12.0 at: altitudeDirection).
	angularVelocity := turnDirection * -0.5.
	angularVelocity abs < 0.001 ifTrue: [ angularVelocity := 0.0 ].
	angularVelocity := angularVelocity * engineDirection abs.
	
	linearAcceleration := (oldTransform transformVector3: engineAcceleration) +
		gravity + buoyancy - (linearVelocity * linearDamping).
	linearVelocity := linearVelocity + (linearAcceleration * delta).

	newTranslation := oldTransform translation + (linearVelocity * delta).
	newTranslation y <= minimalAltitude ifTrue: [ 
		newTranslation y: 0.0.
		linearVelocity y: 0.0.
	].

	currentDriver ifNotNil: [ 
		currentDriver applyVehicleAngleDelta: angularVelocity *delta
	].

	self ownerEntity
		transform: (WMReversibleAffineTransformF identity
			orthonormal: (WMMatrix3F yrot: angularVelocity * delta) * oldTransform matrix translation: newTranslation)
]

{ #category : #accessing }
WDESBalloonVehicleKinematicPhysicsBehavior >> turnDirection [
	^ turnDirection
]

{ #category : #accessing }
WDESBalloonVehicleKinematicPhysicsBehavior >> turnDirection: anObject [
	turnDirection := anObject
]
