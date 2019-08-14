Class {
	#name : #WDESCharacterDrivingVehicleDisplacementStrategy,
	#superclass : #WDESCharacterDisplacementStrategy,
	#instVars : [
		'vehicle'
	],
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #'as yet unclassified' }
WDESCharacterDrivingVehicleDisplacementStrategy >> activateUseCommand [
]

{ #category : #simulation }
WDESCharacterDrivingVehicleDisplacementStrategy >> postPhysicsTick: delta [
	super postPhysicsTick: delta.
	
		character ownerEntity transform: (WMReversibleAffineTransformF identity
			orthonormal: character bodyOrientation translation: self vehicleDriverPosition).
	
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
