Class {
	#name : #WDESPlayerEntity,
	#superclass : #WDESGenericEntity,
	#instVars : [
		'currentEnvironmentFog'
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

{ #category : #environment }
WDESPlayerEntity >> currentFogSettings [
	^ currentEnvironmentFog ifNil: [ super currentFogSettings ]
]

{ #category : #testing }
WDESPlayerEntity >> isPlayerEntity [
	^ true
]
