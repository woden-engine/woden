Class {
	#name : #WTOpenALSoundEngine,
	#superclass : #WDCSoundEngine,
	#pools : [
		'OpenALConstants'
	],
	#category : #'WodenEngine-OpenAL'
}

{ #category : #testing }
WTOpenALSoundEngine class >> isSupported [
	^ OpenAL loadLibrary isNotNil
]

{ #category : #factory }
WTOpenALSoundEngine >> createSoundDevice [
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
	^ WTOpenALSoundDevice new device: alcDevice; context: alcContext; yourself
]
