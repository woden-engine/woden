Class {
	#name : #WDOpenALSoundEngine,
	#superclass : #WDCSoundEngine,
	#pools : [
		'OpenALConstants'
	],
	#category : #'WodenEngine-OpenAL'
}

{ #category : #testing }
WDOpenALSoundEngine class >> isSupported [
	^ OpenAL loadLibrary isNotNil
]

{ #category : #factory }
WDOpenALSoundEngine >> createSoundDevice [
	| alcDevice attributes alcContext |
	alcDevice := OpenALC openDefaultDevice.
	alcDevice ifNil: [ ^ nil ].
	
	attributes := ALContextAttributes new.
	alcContext := alcDevice createContext: attributes asList.
	alcContext ifNil: [ ^ nil ].
	alcContext currentDuring: [ 
		OpenAL listenerf: AL_GAIN value: 0.0.
	].
	alcContext process.
	^ WDOpenALSoundDevice new device: alcDevice; context: alcContext; yourself
]
