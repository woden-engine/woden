Class {
	#name : #WTGSKinematicMovementBehavior,
	#superclass : #WTGSBehavior,
	#instVars : [
		'linearVelocity',
		'linearAcceleration',
		'angularVelocity',
		'angularAcceleration'
	],
	#category : 'WodenEngine-GameSystem-Player'
}

{ #category : #accessing }
WTGSKinematicMovementBehavior >> angularAcceleration [
	^ angularAcceleration
]

{ #category : #accessing }
WTGSKinematicMovementBehavior >> angularAcceleration: anObject [
	angularAcceleration := anObject
]

{ #category : #accessing }
WTGSKinematicMovementBehavior >> angularVelocity [
	^ angularVelocity
]

{ #category : #accessing }
WTGSKinematicMovementBehavior >> angularVelocity: anObject [
	angularVelocity := anObject
]

{ #category : #initialization }
WTGSKinematicMovementBehavior >> initialize [
	super initialize.
	angularVelocity := WMVector3D new.
	angularAcceleration := WMVector3D new.
	linearVelocity := WMVector3D new.
	linearAcceleration := WMVector3D new.

	
]

{ #category : #accessing }
WTGSKinematicMovementBehavior >> linearAcceleration [
	^ linearAcceleration
]

{ #category : #accessing }
WTGSKinematicMovementBehavior >> linearAcceleration: anObject [
	linearAcceleration := anObject
]

{ #category : #accessing }
WTGSKinematicMovementBehavior >> linearVelocity [
	^ linearVelocity
]

{ #category : #accessing }
WTGSKinematicMovementBehavior >> linearVelocity: anObject [
	linearVelocity := anObject
]

{ #category : #'map events' }
WTGSKinematicMovementBehavior >> simulateTime: delta [
	| spatialDesc |
	linearVelocity := linearAcceleration * delta + linearVelocity.
	angularVelocity := angularAcceleration * delta + angularVelocity.
	
	spatialDesc := entity spatialDescription.
	spatialDesc transform
		kinematicTranslateBy: linearVelocity * delta
		rotateByQuaternion: (WMQuaternionD vector3: angularVelocity * delta * 0.5). "TODO: Look this up"
	spatialDesc changed.
]

{ #category : #'map events' }
WTGSKinematicMovementBehavior >> spawn [
	self subscribeToTimeEvents.
]
