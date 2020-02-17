Class {
	#name : #WDESPlayerEntity,
	#superclass : #WDESGenericEntity,
	#instVars : [
		'currentEnvironmentFog',
		'currentEnvironmentSoundGainFactor',
		'isInVirtualReality'
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

{ #category : #initialization }
WDESPlayerEntity >> initialize [
	super initialize.
	isInVirtualReality := false.
]

{ #category : #accessing }
WDESPlayerEntity >> isInVirtualReality [
	^ isInVirtualReality
]

{ #category : #accessing }
WDESPlayerEntity >> isInVirtualReality: anObject [
	isInVirtualReality := anObject
]

{ #category : #testing }
WDESPlayerEntity >> isPlayerEntity [
	^ true
]
