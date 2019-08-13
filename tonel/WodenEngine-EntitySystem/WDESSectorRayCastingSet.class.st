Class {
	#name : #WDESSectorRayCastingSet,
	#superclass : #Object,
	#instVars : [
		'elements'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #removing }
WDESSectorRayCastingSet >> addVolumeComponent: volumeComponent [
	elements add: volumeComponent
]

{ #category : #initialization }
WDESSectorRayCastingSet >> initialize [
	super initialize.
	elements := OrderedCollection new.
]

{ #category : #'ray casting' }
WDESSectorRayCastingSet >> rayCast: ray [
	^ self rayCast: ray withMaxDistance: Float infinity
]

{ #category : #'ray casting' }
WDESSectorRayCastingSet >> rayCast: ray withMaxDistance: maxDistance [
	| bestDistance bestResult distanceResult distance result |
	bestDistance := Float infinity.
	bestResult := nil.
	
	elements do: [ :el |
		distanceResult := el rayCast: ray.
		distance := distanceResult key.
		result := distanceResult value.
		(result notNil and: [ distance < bestDistance and: [ distance < maxDistance ]]) ifTrue: [ 
			bestDistance := distance.
			bestResult := result.
		]
	].

	^ bestDistance -> bestResult.
]

{ #category : #removing }
WDESSectorRayCastingSet >> removeVolumeComponent: volumeComponent [
	elements remove: volumeComponent ifAbsent: [  ]
]

{ #category : #'as yet unclassified' }
WDESSectorRayCastingSet >> send: message from: sender toFirstHitOf: ray [
	^ self send: message from: sender toFirstHitOf: ray withMaxDistance: Float infinity
]

{ #category : #'as yet unclassified' }
WDESSectorRayCastingSet >> send: message from: sender toFirstHitOf: ray withMaxDistance: maxDistance [
	| rayCastResult foundVolume |
	rayCastResult := self rayCast: ray withMaxDistance: maxDistance.
	foundVolume := rayCastResult value.
	foundVolume ifNil: [ ^ nil ].
	
	^ foundVolume activateFrom: sender withRayCastingResult: rayCastResult message: message
]
