Class {
	#name : #WDESWaterVolumeSensorBehaviorComponent,
	#superclass : #WDESVolumeSensorBehaviorComponent,
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #'as yet unclassified' }
WDESWaterVolumeSensorBehaviorComponent >> onTouchWithEntity: collisionEntity atCollisionObject: collisionObject [
	collisionEntity sendEnvironmentSensorEvent: #onUnderwaterVolume: from: self
]
