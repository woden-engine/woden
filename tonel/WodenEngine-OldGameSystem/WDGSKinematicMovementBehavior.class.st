Class {
	#name : #WDGSKinematicMovementBehavior,
	#superclass : #WDGSBehavior,
	#instVars : [
		'linearVelocity',
		'linearAcceleration',
		'angularVelocity',
		'angularAcceleration'
	],
	#category : #'WodenEngine-OldGameSystem-Player'
}

{ #category : #accessing }
WDGSKinematicMovementBehavior >> angularAcceleration [
	^ angularAcceleration
]

{ #category : #accessing }
WDGSKinematicMovementBehavior >> angularAcceleration: anObject [
	angularAcceleration := anObject
]

{ #category : #accessing }
WDGSKinematicMovementBehavior >> angularVelocity [
	^ angularVelocity
]

{ #category : #accessing }
WDGSKinematicMovementBehavior >> angularVelocity: anObject [
	angularVelocity := anObject
]

{ #category : #initialization }
WDGSKinematicMovementBehavior >> initialize [
	super initialize.
	angularVelocity := WMVector3D new.
	angularAcceleration := WMVector3D new.
	linearVelocity := WMVector3D new.
	linearAcceleration := WMVector3D new.

	
]

{ #category : #accessing }
WDGSKinematicMovementBehavior >> linearAcceleration [
	^ linearAcceleration
]

{ #category : #accessing }
WDGSKinematicMovementBehavior >> linearAcceleration: anObject [
	linearAcceleration := anObject
]

{ #category : #accessing }
WDGSKinematicMovementBehavior >> linearVelocity [
	^ linearVelocity
]

{ #category : #accessing }
WDGSKinematicMovementBehavior >> linearVelocity: anObject [
	linearVelocity := anObject
]

{ #category : #'map events' }
WDGSKinematicMovementBehavior >> simulateTime: delta [
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
WDGSKinematicMovementBehavior >> spawn [
	self subscribeToTimeEvents.
]
