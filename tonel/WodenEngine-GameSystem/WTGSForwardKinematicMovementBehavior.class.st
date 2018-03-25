Class {
	#name : #WTGSForwardKinematicMovementBehavior,
	#superclass : #WTGSBehavior,
	#instVars : [
		'angle',
		'linearVelocity',
		'linearAcceleration',
		'angularVelocity',
		'angularAcceleration',
		'movingInGrounding'
	],
	#category : 'WodenEngine-GameSystem-Player'
}

{ #category : #accessing }
WTGSForwardKinematicMovementBehavior >> angularAcceleration [
	^ angularAcceleration
]

{ #category : #accessing }
WTGSForwardKinematicMovementBehavior >> angularAcceleration: anObject [
	angularAcceleration := anObject
]

{ #category : #accessing }
WTGSForwardKinematicMovementBehavior >> angularVelocity [
	^ angularVelocity
]

{ #category : #accessing }
WTGSForwardKinematicMovementBehavior >> angularVelocity: anObject [
	angularVelocity := anObject
]

{ #category : #initialization }
WTGSForwardKinematicMovementBehavior >> initialize [
	super initialize.
	angle := WMVector3D new.
	angularVelocity := WMVector3D new.
	angularAcceleration := WMVector3D new.
	linearVelocity := WMVector3D new.
	linearAcceleration := WMVector3D new.
	movingInGrounding := true.
]

{ #category : #accessing }
WTGSForwardKinematicMovementBehavior >> linearAcceleration [
	^ linearAcceleration
]

{ #category : #accessing }
WTGSForwardKinematicMovementBehavior >> linearAcceleration: anObject [
	linearAcceleration := anObject
]

{ #category : #accessing }
WTGSForwardKinematicMovementBehavior >> linearVelocity [
	^ linearVelocity
]

{ #category : #accessing }
WTGSForwardKinematicMovementBehavior >> linearVelocity: anObject [
	linearVelocity := anObject
]

{ #category : #'map events' }
WTGSForwardKinematicMovementBehavior >> simulateTime: delta [
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
WTGSForwardKinematicMovementBehavior >> spawn [
	self subscribeToTimeEvents.
]
