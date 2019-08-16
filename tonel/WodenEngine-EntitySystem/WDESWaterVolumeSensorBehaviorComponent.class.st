Class {
	#name : #WDESWaterVolumeSensorBehaviorComponent,
	#superclass : #WDESVolumeSensorBehaviorComponent,
	#instVars : [
		'environmentFogSettings'
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

{ #category : #'as yet unclassified' }
WDESWaterVolumeSensorBehaviorComponent >> onTouchWithEntity: collisionEntity atCollisionObject: collisionObject [
	collisionEntity sendEnvironmentSensorEvent: #onUnderwaterVolume: from: self
]
