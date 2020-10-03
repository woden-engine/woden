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
	
	linearVelocity := Float32x3 zeros.
	linearAcceleration := Float32x3 zeros.
	
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
	engineAcceleration := Float32x3 z: engineDirection negated * self maxEngineAcceleration.
	
	gravity := Float32x3 y: -9.8.
	buoyancy := Float32x3 y: (0.0 interpolateTo: 12.0 at: altitudeDirection).
	angularVelocity := turnDirection * -0.5.
	angularVelocity abs < 0.001 ifTrue: [ angularVelocity := 0.0 ].
	angularVelocity := angularVelocity * engineDirection abs.
	
	linearAcceleration := (oldTransform transformVector: engineAcceleration) +
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
		transform: (ReversibleAffineTransform3dF32 identity
			orthonormal: (Float32x3x3 yRotation: angularVelocity * delta) * oldTransform matrix translation: newTranslation)
]

{ #category : #accessing }
WDESBalloonVehicleKinematicPhysicsBehavior >> turnDirection [
	^ turnDirection
]

{ #category : #accessing }
WDESBalloonVehicleKinematicPhysicsBehavior >> turnDirection: anObject [
	turnDirection := anObject
]
