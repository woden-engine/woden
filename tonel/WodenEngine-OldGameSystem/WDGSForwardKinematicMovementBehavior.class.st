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
	angle := WMVector3D new.
	angularVelocity := WMVector3D new.
	angularAcceleration := WMVector3D new.
	linearVelocity := WMVector3D new.
	linearAcceleration := WMVector3D new.
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
		orientation := (WMMatrix3D yrot: angle y).
	] ifFalse: [
		orientation := (WMMatrix3D yrot: angle y) * (WMMatrix3D xrot: angle x).
	].

	spatialDesc := entity spatialDescription.
	spatialDesc transform
			orthonormal: orientation;
			translateBy: (orientation transformVector3: linearVelocity * delta).
	spatialDesc changed.
]

{ #category : #'map events' }
WDGSForwardKinematicMovementBehavior >> spawn [
	self subscribeToTimeEvents.
]
