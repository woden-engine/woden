Class {
	#name : #WDGSForwardKinematicMovementBehavior,
	#superclass : #WDGSBehavior,
	#instVars : [
		'angle',
		'linearVelocity',
		'linearAcceleration',
		'angularVelocity',
		'angularAcceleration',
		'movingInGrounding'
	],
	#category : #'WodenEngine-OldGameSystem-Player'
}

{ #category : #accessing }
WDGSForwardKinematicMovementBehavior >> angularAcceleration [
	^ angularAcceleration
]

{ #category : #accessing }
WDGSForwardKinematicMovementBehavior >> angularAcceleration: anObject [
	angularAcceleration := anObject
]

{ #category : #accessing }
WDGSForwardKinematicMovementBehavior >> angularVelocity [
	^ angularVelocity
]

{ #category : #accessing }
WDGSForwardKinematicMovementBehavior >> angularVelocity: anObject [
	angularVelocity := anObject
]

{ #category : #initialization }
WDGSForwardKinematicMovementBehavior >> initialize [
	super initialize.
	angle := Float64x3 new.
	angularVelocity := Float64x3 new.
	angularAcceleration := Float64x3 new.
	linearVelocity := Float64x3 new.
	linearAcceleration := Float64x3 new.
	movingInGrounding := true.
]

{ #category : #accessing }
WDGSForwardKinematicMovementBehavior >> linearAcceleration [
	^ linearAcceleration
]

{ #category : #accessing }
WDGSForwardKinematicMovementBehavior >> linearAcceleration: anObject [
	linearAcceleration := anObject
]

{ #category : #accessing }
WDGSForwardKinematicMovementBehavior >> linearVelocity [
	^ linearVelocity
]

{ #category : #accessing }
WDGSForwardKinematicMovementBehavior >> linearVelocity: anObject [
	linearVelocity := anObject
]

{ #category : #'map events' }
WDGSForwardKinematicMovementBehavior >> simulateTime: delta [
	| spatialDesc orientation |
	linearVelocity := linearAcceleration * delta + linearVelocity.
	angularVelocity := angularAcceleration * delta + angularVelocity.
	
	angle := angle + (angularVelocity * delta).
	movingInGrounding ifTrue: [
		orientation := (Float64x3x3 yRotation: angle y).
	] ifFalse: [
		orientation := (Float64x3x3 yRotation: angle y) * (Float64x3x3 xRotation: angle x).
	].

	spatialDesc := entity spatialDescription.
	spatialDesc transform
			orthonormal: orientation;
			translateBy: orientation * (linearVelocity * delta).
	spatialDesc changed.
]

{ #category : #'map events' }
WDGSForwardKinematicMovementBehavior >> spawn [
	self subscribeToTimeEvents.
]
