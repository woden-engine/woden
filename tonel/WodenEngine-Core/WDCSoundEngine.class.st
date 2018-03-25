Class {
	#name : #WDCSoundEngine,
	#superclass : #Object,
	#classVars : [
		'CurrentEngine',
		'SoundSession'
	],
	#category : 'WodenEngine-Core-Sound'
}

{ #category : #accessing }
WDCSoundEngine class >> checkAndLoadEngine [
	(CurrentEngine == nil or: [ SoundSession ~~ Smalltalk session ]) ifTrue: [ 
		CurrentEngine := self pickEngine.
		SoundSession := Smalltalk session.
	].
]

{ #category : #accessing }
WDCSoundEngine class >> current [
	self checkAndLoadEngine.
	CurrentEngine ifNil: [ self error: 'Not supported sound engine found.' ].
	^ CurrentEngine
]

{ #category : #testing }
WDCSoundEngine class >> isAvailable [
	self checkAndLoadEngine.
	^ CurrentEngine ~~ nil.
]

{ #category : #testing }
WDCSoundEngine class >> isSupported [
	^ false
]

{ #category : #initialisation }
WDCSoundEngine class >> pickEngine [
	self allSubclasses do: [ :sc  | sc isSupported ifTrue: [ ^ sc new ] ].
	^ nil
]

{ #category : #factory }
WDCSoundEngine >> createSoundDevice [
	self subclassResponsibility
]
