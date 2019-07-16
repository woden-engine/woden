Trait {
	#name : #TEnvironmentSensitiveBehavior,
	#category : #'WodenEngine-EntitySystem-Behaviors'
}

{ #category : #events }
TEnvironmentSensitiveBehavior >> onUnderwaterVolume: underwaterVolumeComponent [
]

{ #category : #messages }
TEnvironmentSensitiveBehavior >> sendEnvironmentSensorEvent: environmentEventSelector from: senderComponent [
	^ self perform: environmentEventSelector with: senderComponent
]
