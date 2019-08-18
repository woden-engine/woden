Class {
	#name : #WDESWaterVolumeSensorBehaviorComponent,
	#superclass : #WDESVolumeSensorBehaviorComponent,
	#instVars : [
		'environmentFogSettings',
		'environmentSoundGainFactor',
		'environmentSoundPitchFactor'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESWaterVolumeSensorBehaviorComponent >> environmentFogSettings [
	^ environmentFogSettings ifNil: [ environmentFogSettings := WDESFogSettings defaultUnderwaterFogSettings ]
]

{ #category : #accessing }
WDESWaterVolumeSensorBehaviorComponent >> environmentFogSettings: newFogSettings [
	environmentFogSettings := newFogSettings
]

{ #category : #accessing }
WDESWaterVolumeSensorBehaviorComponent >> environmentSoundGainFactor [
	^ environmentSoundGainFactor
]

{ #category : #accessing }
WDESWaterVolumeSensorBehaviorComponent >> environmentSoundGainFactor: anObject [
	environmentSoundGainFactor := anObject
]

{ #category : #accessing }
WDESWaterVolumeSensorBehaviorComponent >> environmentSoundPitchFactor [
	^ environmentSoundPitchFactor
]

{ #category : #accessing }
WDESWaterVolumeSensorBehaviorComponent >> environmentSoundPitchFactor: anObject [
	environmentSoundPitchFactor := anObject
]

{ #category : #'as yet unclassified' }
WDESWaterVolumeSensorBehaviorComponent >> onTouchWithEntity: collisionEntity atCollisionObject: collisionObject [
	collisionEntity sendEnvironmentSensorEvent: #onUnderwaterVolume: from: self
]
