Class {
	#name : #WDESCharacterDrivingVehicleDisplacementStrategy,
	#superclass : #WDESCharacterDisplacementStrategy,
	#instVars : [
		'vehicle',
		'vehicleKinematicBehavior'
	],
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #'as yet unclassified' }
WDESCharacterDrivingVehicleDisplacementStrategy >> activateUseCommand [
	character useWalkingDisplacementStrategy.
	vehicleKinematicBehavior currentDriver: self
]

{ #category : #testing }
WDESCharacterDrivingVehicleDisplacementStrategy >> isRotatingFullBody [
	^ false
]

{ #category : #simulation }
WDESCharacterDrivingVehicleDisplacementStrategy >> postPhysicsTick: delta [
	super postPhysicsTick: delta.
	
	character ownerEntity transform: (WMReversibleAffineTransformF identity
		orthonormal: character bodyOrientation translation: self vehicleDriverPosition).
	
]

{ #category : #simulation }
WDESCharacterDrivingVehicleDisplacementStrategy >> prePhysicsTick: delta [
	super prePhysicsTick: delta.
	self adjustHeadAndBodyOrientations.
]

{ #category : #hooks }
WDESCharacterDrivingVehicleDisplacementStrategy >> usingPhysicsObject [
	^ false
]

{ #category : #accessing }
WDESCharacterDrivingVehicleDisplacementStrategy >> vehicle [
	^ vehicle
]

{ #category : #accessing }
WDESCharacterDrivingVehicleDisplacementStrategy >> vehicle: anObject [
	vehicle := anObject
]

{ #category : #hooks }
WDESCharacterDrivingVehicleDisplacementStrategy >> vehicleDriverPosition [
	^ self subclassResponsibility
]

{ #category : #accessing }
WDESCharacterDrivingVehicleDisplacementStrategy >> vehicleKinematicBehavior [
	^ vehicleKinematicBehavior
]

{ #category : #accessing }
WDESCharacterDrivingVehicleDisplacementStrategy >> vehicleKinematicBehavior: anObject [
	vehicleKinematicBehavior := anObject.
	vehicleKinematicBehavior currentDriver: self
]
