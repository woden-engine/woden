Class {
	#name : #WDESRayCastingBoxVolumeComponent,
	#superclass : #WDESComponent,
	#traits : 'TWDESRayCastingBoxVolume',
	#classTraits : 'TWDESRayCastingBoxVolume classTrait',
	#instVars : [
		'actionBlock',
		'boxVolume'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESRayCastingBoxVolumeComponent >> actionBlock [
	^ actionBlock
]

{ #category : #accessing }
WDESRayCastingBoxVolumeComponent >> actionBlock: anObject [
	actionBlock := anObject
]

{ #category : #'as yet unclassified' }
WDESRayCastingBoxVolumeComponent >> activateFrom: sender withRayCastingResult: rayCastingResult message: activationMessage [
	actionBlock ifNotNil: [
		actionBlock cull: sender cull: rayCastingResult cull: activationMessage
	]
]

{ #category : #notifications }
WDESRayCastingBoxVolumeComponent >> addedToSector: aSector [
	(self rayCastingSetForSector: aSector) addVolumeComponent: self
]

{ #category : #accessing }
WDESRayCastingBoxVolumeComponent >> boxVolume [
	^ boxVolume
]

{ #category : #accessing }
WDESRayCastingBoxVolumeComponent >> boxVolume: anObject [
	boxVolume := anObject
]

{ #category : #initialization }
WDESRayCastingBoxVolumeComponent >> initialize [
	super initialize.
	boxVolume := BoxF32 new.
]

{ #category : #notifications }
WDESRayCastingBoxVolumeComponent >> rayCastingSetForSector: aSector [
	self subclassResponsibility
]

{ #category : #notifications }
WDESRayCastingBoxVolumeComponent >> removedFromSector: aSector [
	(self rayCastingSetForSector: aSector) removeVolumeComponent: self
]

{ #category : #accessing }
WDESRayCastingBoxVolumeComponent >> volumeGlobalTransform [
	^ self ownerEntity sectorTransform
]

{ #category : #'as yet unclassified' }
WDESRayCastingBoxVolumeComponent >> volumeOwnerComponent [
	^ self
]

{ #category : #'as yet unclassified' }
WDESRayCastingBoxVolumeComponent >> volumeOwnerEntity [
	^ self ownerEntity
]
