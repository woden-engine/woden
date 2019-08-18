Class {
	#name : #WDESPlayerEntity,
	#superclass : #WDESGenericEntity,
	#instVars : [
		'currentEnvironmentFog',
		'currentEnvironmentSoundGainFactor'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESPlayerEntity >> currentEnvironmentFog [
	^ currentEnvironmentFog
]

{ #category : #accessing }
WDESPlayerEntity >> currentEnvironmentFog: anObject [
	currentEnvironmentFog := anObject
]

{ #category : #accessing }
WDESPlayerEntity >> currentEnvironmentSoundGainFactor: anObject [
	currentEnvironmentSoundGainFactor := anObject
]

{ #category : #environment }
WDESPlayerEntity >> currentFogSettings [
	^ currentEnvironmentFog ifNil: [ super currentFogSettings ]
]

{ #category : #environment }
WDESPlayerEntity >> currentSoundGainFactor [
	^ currentEnvironmentSoundGainFactor ifNil: [ super currentSoundGainFactor ]
]

{ #category : #testing }
WDESPlayerEntity >> isPlayerEntity [
	^ true
]
